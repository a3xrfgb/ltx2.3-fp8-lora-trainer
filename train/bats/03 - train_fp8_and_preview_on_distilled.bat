@echo off
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

echo ============================================
echo   STAGE 1: Training
echo ============================================

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
  --max_train_steps 5000 ^
  --sample_at_first ^
  --sample_every_n_steps 250 ^
  --sample_prompts train\sampling_prompts.txt ^
  --sample_with_offloading ^
  --sample_tiled_vae ^
  --sample_vae_tile_size 512 ^
  --sample_vae_tile_overlap 64 ^
  --sample_vae_temporal_tile_size 48 ^
  --sample_vae_temporal_tile_overlap 8 ^
  --sample_merge_audio ^
  --save_every_n_steps 250 ^
  --save_last_n_steps 30 ^
  --output_dir output ^
  --output_name ltx23_lora

if errorlevel 1 (
    echo.
    echo Training exited with an error - skipping distilled preview.
    pause
    exit /b 1
)

echo ============================================
echo   STAGE 2: Distilled preview of final LoRA
echo ============================================

REM Find the most recently saved LoRA checkpoint (skips the ComfyUI copy)
set LORA_FILE=
for /f "delims=" %%F in ('dir /b /o-d "output\ltx23_lora*.safetensors" 2^>nul ^| findstr /v /i "comfy"') do (
    if not defined LORA_FILE set LORA_FILE=output\%%F
)

if not defined LORA_FILE (
    echo No saved LoRA checkpoint found in output\ - skipping preview.
    pause
    exit /b 1
)

echo Using LoRA checkpoint: %LORA_FILE%

python src\musubi_tuner\ltx2_generate_video.py ^
  --ltx2_checkpoint models\ltx-2.3-22b-distilled-fp8.safetensors ^
  --gemma_safetensors models\gemma_3_12B_it_fp8_e4m3fn.safetensors ^
  --lora_weight %LORA_FILE% ^
  --lora_multiplier 1.0 ^
  --from_file train\sampling_prompts.txt ^
  --steps 6 ^
  --guidance_scale 1 ^
  --save_path output\distilled_preview

echo.
echo Done. Check output\sample for dev-based training samples
echo and output\distilled_preview for the fast distilled preview.
pause
