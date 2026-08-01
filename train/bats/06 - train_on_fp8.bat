@echo off
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

echo ============================================
echo   Training LoRA on dev-fp8 checkpoint
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
  --output_dir output ^
  --output_name ltx23_lora_fp8

if errorlevel 1 (
    echo.
    echo Training exited with an error.
    pause
    exit /b 1
)

echo ============================================
echo   Cleaning up samples - keeping merged video+audio only
echo ============================================

setlocal enabledelayedexpansion
for %%F in (output\sample\*.mp4) do (
    set "HASAUDIO="
    for /f "delims=" %%A in ('ffprobe -v error -select_streams a -show_entries stream=codec_type -of csv=p=0 "%%F" 2^>nul') do set "HASAUDIO=%%A"
    if not defined HASAUDIO (
        echo Deleting silent video: %%F
        del "%%F"
    )
)
del /q output\sample\*.wav 2>nul
endlocal

echo.
echo Done. output\sample now contains only merged video+audio files.
pause
