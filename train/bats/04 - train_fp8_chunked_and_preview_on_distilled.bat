@echo off
setlocal enabledelayedexpansion
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

REM ---- Test with MAX_STEPS=500 first to verify --resume works correctly ----
REM ---- before trusting this for a full unattended run.                    ----
set STEP_CHUNK=250
set MAX_STEPS=5000
set CURRENT_TARGET=0

:LOOP
set /a CURRENT_TARGET+=%STEP_CHUNK%

echo ============================================
echo   Training toward step %CURRENT_TARGET% of %MAX_STEPS%
echo ============================================

REM Find the most recently saved state folder to resume from (none on first cycle)
set RESUME_DIR=
for /f "delims=" %%D in ('dir /b /ad /o-d "output\ltx23_lora*-state" 2^>nul') do (
    if not defined RESUME_DIR set RESUME_DIR=output\%%D
)

set RESUME_ARG=
if defined RESUME_DIR (
    echo Resuming from: %RESUME_DIR%
    set RESUME_ARG=--resume "%RESUME_DIR%"
) else (
    echo No prior state found - starting fresh.
)

accelerate launch --num_cpu_threads_per_process 1 --mixed_precision bf16 src\musubi_tuner\ltx2_train_network.py ^
  --mixed_precision bf16 ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev-fp8.safetensors ^
  --ltx_version 2.3 ^
  --ltx_version_check_mode error ^
  --ltx2_mode av ^
  --separate_audio_buckets ^
  --fp8_base ^
  --fp8_scaled ^
  --blocks_to_swap 0 ^
  --sdpa ^
  --gradient_checkpointing ^
  --learning_rate 1e-4 ^
  --optimizer_type adamw8bit ^
  --network_module networks.lora_ltx2 ^
  --network_dim 32 ^
  --network_alpha 32 ^
  --timestep_sampling shifted_logit_normal ^
  --gemma_safetensors models\gemma_3_12B_it_fp8_e4m3fn.safetensors ^
  --max_train_steps %CURRENT_TARGET% ^
  --save_every_n_steps %STEP_CHUNK% ^
  --save_last_n_steps 30 ^
  --save_state ^
  --save_state_on_train_end ^
  --output_dir output ^
  --output_name ltx23_lora ^
  %RESUME_ARG%

if errorlevel 1 (
    echo.
    echo Training chunk failed - stopping loop.
    pause
    exit /b 1
)

echo ============================================
echo   Distilled preview at step %CURRENT_TARGET%
echo ============================================

set LORA_FILE=
for /f "delims=" %%F in ('dir /b /o-d "output\ltx23_lora*.safetensors" 2^>nul ^| findstr /v /i "comfy"') do (
    if not defined LORA_FILE set LORA_FILE=output\%%F
)

if defined LORA_FILE (
    echo Using checkpoint: %LORA_FILE%
    python src\musubi_tuner\ltx2_generate_video.py ^
      --ltx2_checkpoint models\ltx-2.3-22b-distilled-fp8.safetensors ^
      --gemma_safetensors models\gemma_3_12B_it_fp8_e4m3fn.safetensors ^
      --lora_weight %LORA_FILE% ^
      --lora_multiplier 1.0 ^
      --from_file train\sampling_prompts.txt ^
      --steps 6 ^
      --guidance_scale 1 ^
      --save_path output\distilled_preview\step_%CURRENT_TARGET%
) else (
    echo No LoRA checkpoint found yet - skipping preview this cycle.
)

if %CURRENT_TARGET% LSS %MAX_STEPS% goto LOOP

echo.
echo ============================================
echo   All done - reached %MAX_STEPS% steps.
echo   Previews saved per-step under output\distilled_preview\
echo ============================================
pause
