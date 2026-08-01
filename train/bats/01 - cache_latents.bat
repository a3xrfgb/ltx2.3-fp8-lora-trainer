@echo off
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

python src\musubi_tuner\ltx2_cache_latents.py ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev-fp8.safetensors ^
  --device cuda ^
  --vae_dtype bf16 ^
  --ltx2_mode av ^
  --ltx2_audio_source video

pause
