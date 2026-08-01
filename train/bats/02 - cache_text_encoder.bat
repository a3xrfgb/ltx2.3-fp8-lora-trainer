@echo off
cd /d "C:\Github\node canvas ai\musubi-tuner"
call venv\Scripts\activate

python src\musubi_tuner\ltx2_cache_text_encoder_outputs.py ^
  --dataset_config train\dataset.toml ^
  --ltx2_checkpoint models\ltx-2.3-22b-dev-fp8.safetensors ^
  --gemma_safetensors models\gemma_3_12B_it_fp8_e4m3fn.safetensors ^
  --device cuda ^
  --mixed_precision bf16 ^
  --ltx2_mode av ^
  --batch_size 1 ^
  --precache_sample_prompts ^
  --sample_prompts train\sampling_prompts.txt

pause
