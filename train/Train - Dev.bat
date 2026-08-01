@echo off
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

echo ============================================
echo   Step 1: Caching Latents
echo ============================================
python src\musubi_tuner\ltx2_cache_latents.py ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev.safetensors ^
  --device cuda ^
  --vae_dtype bf16 ^
  --ltx2_mode av ^
  --ltx2_audio_source video

if errorlevel 1 (
    echo.
    echo Latent caching exited with an error.
    pause
    exit /b 1
)

echo ============================================
echo   Step 2: Caching Text Encoder Outputs
echo ============================================
python src\musubi_tuner\ltx2_cache_text_encoder_outputs.py ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev.safetensors ^
  --gemma_safetensors models\gemma_3_12B_it_fp8_e4m3fn.safetensors ^
  --device cuda ^
  --mixed_precision bf16 ^
  --ltx2_mode av ^
  --batch_size 1

if errorlevel 1 (
    echo.
    echo Text encoder caching exited with an error.
    pause
    exit /b 1
)

echo ============================================
echo   Step 3: Training LoRA on dev checkpoint
echo ============================================
accelerate launch --num_cpu_threads_per_process 1 --mixed_precision bf16 src\musubi_tuner\ltx2_train_network.py ^
  --mixed_precision bf16 ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev.safetensors ^
  --ltx_version 2.3 ^
  --ltx_version_check_mode error ^
  --ltx2_mode av ^
  --separate_audio_buckets ^
  --blocks_to_swap 0 ^
  --sdpa ^
  --gradient_checkpointing ^
  --learning_rate 1e-4 ^
  --optimizer_type adamw8bit ^
  --network_module networks.lora_ltx2 ^
  --network_dim 32 ^
  --network_alpha 32 ^
  --timestep_sampling shifted_logit_normal ^
  --max_train_steps 5000 ^
  --save_every_n_steps 250 ^
  --save_last_n_steps 9999 ^
  --output_dir output ^
  --output_name ltx23_lora_dev

if errorlevel 1 (
    echo.
    echo Training exited with an error.
    pause
    exit /b 1
)

echo.
echo Done. Pipeline finished successfully!
pause