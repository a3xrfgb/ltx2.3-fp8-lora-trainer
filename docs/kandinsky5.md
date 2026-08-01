> 📝 Click on the language section to expand / 言語をクリックして展開

# Kandinsky 5

## Overview / 概要

This is an unofficial training and inference script for [Kandinsky 5](https://github.com/ai-forever/Kandinsky-5). The features are as follows:

- fp8 support and memory reduction by block swap
- Inference without installing Flash attention (using PyTorch's scaled dot product attention)
- LoRA training for text-to-video (T2V) and image-to-video (I2V, Pro) models

This feature is experimental.

<details>
<summary>日本語</summary>

[Kandinsky 5](https://github.com/ai-forever/Kandinsky-5) の非公式の学習および推論スクリプトです。

以下の特徴があります：

- fp8対応およびblock swapによる省メモリ化
- Flash attentionのインストールなしでの実行（PyTorchのscaled dot product attentionを使用）
- テキストから動画（T2V）および画像から動画（I2V、Pro）モデルのLoRA学習

この機能は実験的なものです。

</details>

## Download the model / モデルのダウンロード

Download the model weights from the [Kandinsky 5.0 Collection](https://huggingface.co/collections/ai-forever/kandinsky-50) on Hugging Face.

### DiT Model / DiTモデル

This document focuses on **Pro** models. The trainer also works with **Lite** models.
本ドキュメントでは **Pro** モデルを中心に説明しますが、トレーナーは **Lite** モデルでも動作します。

Download a Pro DiT `.safetensors` checkpoint from the Kandinsky 5.0 Collection (e.g. `kandinsky5pro_t2v_pretrain_5s.safetensors` or `kandinsky5pro_i2v_sft_5s.safetensors`).

### VAE

Kandinsky 5 uses the HunyuanVideo 3D VAE. Download `diffusion_pytorch_model.safetensors` (or `pytorch_model.pt`) from:
https://huggingface.co/hunyuanvideo-community/HunyuanVideo

### Text Encoders / テキストエンコーダ

Kandinsky 5 uses Qwen2.5-VL-7B and CLIP for text encoding.

**Qwen2.5-VL-7B**: Download from https://huggingface.co/Qwen/Qwen2.5-VL-7B-Instruct (or use the path to your local Qwen/Qwen2.5-VL-7B-Instruct model)

**CLIP**: Use the Hugging Face Transformers model `openai/clip-vit-large-patch14`.

Pass either the model ID (e.g., `--text_encoder_clip openai/clip-vit-large-patch14`) or a path to the locally cached snapshot directory.

### Directory Structure / ディレクトリ構造

Place them in your chosen directory structure:

```
weights/
├── model/
│   └── kandinsky5pro_t2v_pretrain_5s.safetensors
├── vae/
│   └── diffusion_pytorch_model.safetensors
├── text_encoder/
│   └── (Qwen2.5-VL-7B files)
└── text_encoder2/
    └── (openai/clip-vit-large-patch14 files)
```

<details>
<summary>日本語</summary>

Hugging Faceの[Kandinsky 5.0 Collection](https://huggingface.co/collections/ai-forever/kandinsky-50)からモデルの重みをダウンロードしてください。

このドキュメントは **Proモデル** を前提に説明しています。

**DiTモデル**: 上記のリポジトリから`.safetensors`ファイルをダウンロードしてください。

**VAE**: Kandinsky 5はHunyuanVideo 3D VAEを使用します。上記リンクから`diffusion_pytorch_model.safetensors`（または`pytorch_model.pt`）をダウンロードしてください。

**テキストエンコーダ**: Qwen2.5-VL-7BとCLIPを使用します。

**Qwen2.5-VL-7B**: https://huggingface.co/Qwen/Qwen2.5-VL-7B-Instruct からダウンロードしてください（またはローカルの `Qwen/Qwen2.5-VL-7B-Instruct` を指定します）。

**CLIP**: Hugging Face Transformersの `openai/clip-vit-large-patch14` を使用してください（モデルIDまたはローカルにキャッシュされたsnapshotディレクトリへのパスを指定します）。

任意のディレクトリ構造に配置してください。

</details>

## List of Kandinsky 5 models / 利用可能なタスク

The `--task` option selects a model configuration (architecture, attention type, resolution, and default parameters).
The DiT checkpoint must be set explicitly via `--dit` (this overrides the task's default checkpoint path).

| # | Task | Checkpoint | Parameters | HF URL |
|---|---|---|---|---|
| 1 | k5-pro-t2v-5s-sd | kandinsky5pro_t2v_sft_5s.safetensors | T2V, 5s, 19B, Pro SFT | [kandinskylab/Kandinsky-5.0-T2V-Pro-sft-5s](https://huggingface.co/kandinskylab/Kandinsky-5.0-T2V-Pro-sft-5s) |
| 2 | k5-pro-t2v-10s-sd | kandinsky5pro_t2v_sft_10s.safetensors | T2V, 10s, 19B, Pro SFT | [kandinskylab/Kandinsky-5.0-T2V-Pro-sft-10s](https://huggingface.co/kandinskylab/Kandinsky-5.0-T2V-Pro-sft-10s) |
| 3 | k5-pro-i2v-5s-sd | kandinsky5pro_i2v_sft_5s.safetensors | I2V, 5s, 19B, Pro SFT | [kandinskylab/Kandinsky-5.0-I2V-Pro-sft-5s](https://huggingface.co/kandinskylab/Kandinsky-5.0-I2V-Pro-sft-5s) |
| 4 | k5-pro-t2v-5s-sd | kandinsky5pro_t2v_pretrain_5s.safetensors | T2V, 5s, 19B, Pro Pretrain | [kandinskylab/Kandinsky-5.0-T2V-Pro-pretrain-5s](https://huggingface.co/kandinskylab/Kandinsky-5.0-T2V-Pro-pretrain-5s) |
| 5 | k5-pro-t2v-10s-sd | kandinsky5pro_t2v_pretrain_10s.safetensors | T2V, 10s, 19B, Pro Pretrain | [kandinskylab/Kandinsky-5.0-T2V-Pro-pretrain-10s](https://huggingface.co/kandinskylab/Kandinsky-5.0-T2V-Pro-pretrain-10s) |

[Kandinsky 5.0 Video Lite models](https://huggingface.co/collections/kandinskylab/kandinsky-50-video-lite) are technically supported, but were not extensively tested. Community feedback is welcome.

[Kandinsky 5.0 Image Lite models](https://huggingface.co/collections/kandinskylab/kandinsky-50-image-lite) are not supported, but support can be implemented if they get active support from the community.

<details>
<summary>日本語</summary>

`--task` オプションでタスク設定（アーキテクチャ、attention、解像度、各種デフォルト値）を選択します。
DiTのチェックポイントは `--dit` で明示的に指定できます（タスクのデフォルトのパスを上書きします）。

Kandinsky 5.0 Video Liteモデル（https://huggingface.co/collections/kandinskylab/kandinsky-50-video-lite）は技術的にはサポートされていますが、十分な動作確認はできていません。問題があればフィードバックをお願いします。

Kandinsky 5.0 Image Liteモデル（https://huggingface.co/collections/kandinskylab/kandinsky-50-image-lite）は現在サポートしていませんが、コミュニティからの継続的な要望・協力があれば対応可能です。

</details>

## Pre-caching / 事前キャッシュ

Pre-caching is required before training. This involves caching both latents and text encoder outputs.

### Notes for Kandinsky5 / Kandinsky5の注意点

- You must cache **text encoder outputs** with `kandinsky5_cache_text_encoder_outputs.py` before training.
- `--text_encoder_qwen` / `--text_encoder_clip` are Hugging Face Transformers models: pass a model ID (recommended) or a local HF snapshot directory.
- For I2V tasks, the latent cache stores both first and last frame latents (`latents_image`, always two frames) when running `kandinsky5_cache_latents.py`—one cache works for both first-only and first+last conditioning.

<details>
<summary>日本語</summary>

- 学習前に、`kandinsky5_cache_text_encoder_outputs.py` による **テキストエンコーダ出力のキャッシュ** が必須です。
- `--text_encoder_qwen` / `--text_encoder_clip` はHugging Face Transformersのモデルです。モデルID（推奨）またはローカルのHF snapshotディレクトリを指定してください。
- I2Vタスクでは、`kandinsky5_cache_latents.py` 実行時に最初と最後のフレームlatent（`latents_image`、常に2フレーム）もキャッシュされます。1回のキャッシュで first / first+last 両方のモードに対応できます。

</details>

### Text Encoder Output Pre-caching / テキストエンコーダ出力の事前キャッシュ

Text encoder output pre-caching is required. Create the cache using the following command:

```bash
python kandinsky5_cache_text_encoder_outputs.py \
    --dataset_config path/to/dataset.toml \
    --text_encoder_qwen Qwen/Qwen2.5-VL-7B-Instruct \
    --text_encoder_clip openai/clip-vit-large-patch14 \
    --batch_size 4
```

Adjust `--batch_size` according to your available VRAM.

For additional options, use `python kandinsky5_cache_text_encoder_outputs.py --help`.

<details>
<summary>日本語</summary>

テキストエンコーダ出力の事前キャッシュは必須です。上のコマンド例を使用してキャッシュを作成してください。

使用可能なVRAMに合わせて `--batch_size` を調整してください。

その他のオプションは `--help` で確認できます。

</details>

### Latent Pre-caching / latentの事前キャッシュ

Latent pre-caching is required. Create the cache using the following command:

```bash
python kandinsky5_cache_latents.py \
    --dataset_config path/to/dataset.toml \
    --vae path/to/vae/diffusion_pytorch_model.safetensors
```

For NABLA training, you may want to build NABLA-compatible latent caches:

```bash
python kandinsky5_cache_latents.py \
    --dataset_config path/to/dataset.toml \
    --vae path/to/vae/diffusion_pytorch_model.safetensors \
    --nabla_resize
```

If you're running low on VRAM, lower the `--batch_size`.

For additional options, use `python kandinsky5_cache_latents.py --help`.

<details>
<summary>日本語</summary>

latentの事前キャッシュは必須です。上のコマンド例を使用してキャッシュを作成してください。

VRAMが足りない場合は、`--batch_size`を小さくしてください。

NABLAで学習する場合は、NABLA互換のlatentキャッシュを作成することを推奨します：

```bash
python kandinsky5_cache_latents.py \
    --dataset_config path/to/dataset.toml \
    --vae path/to/vae/diffusion_pytorch_model.safetensors \
    --nabla_resize
```

その他のオプションは `--help` で確認できます。

</details>

## Training / 学習

Start training using the following command (input as a single line):

```bash
accelerate launch --num_cpu_threads_per_process 1 --mixed_precision bf16 \
    kandinsky5_train_network.py \
    --mixed_precision bf16 \
    --dataset_config path/to/dataset.toml \
    --task k5-pro-t2v-5s-sd \
    --dit path/to/kandinsky5pro_t2v_pretrain_5s.safetensors \
    --text_encoder_qwen Qwen/Qwen2.5-VL-7B-Instruct \
    --text_encoder_clip openai/clip-vit-large-patch14 \
    --vae path/to/vae/diffusion_pytorch_model.safetensors \
    --fp8_base \
    --sdpa \
    --gradient_checkpointing \
    --max_data_loader_n_workers 1 \
    --persistent_data_loader_workers \
    --learning_rate 1e-4 \
    --optimizer_type AdamW8Bit \
    --optimizer_args "weight_decay=0.001" "betas=(0.9,0.95)" \
    --max_grad_norm 1.0 \
    --lr_scheduler constant_with_warmup \
    --lr_warmup_steps 100 \
    --network_module networks.lora_kandinsky \
    --network_dim 32 \
    --network_alpha 32 \
    --timestep_sampling shift \
    --discrete_flow_shift 5.0 \
    --output_dir path/to/output \
    --output_name k5_lora \
    --save_every_n_epochs 1 \
    --max_train_epochs 50 \
    --scheduler_scale 10.0
```

For I2V training, switch the task and checkpoint to an I2V preset (e.g., `k5-pro-i2v-5s-sd` with `kandinsky5pro_i2v_sft_5s.safetensors`). The latent cache already stores first and last frame latents (`latents_image`, two frames) when you run `kandinsky5_cache_latents.py`, so the same cache covers both first-only and first+last modes—no extra flags are needed beyond picking an I2V task.

**Note on first+last frame conditioning**: First+last frame training support is experimental. The effectiveness and plausibility of this approach have not yet been thoroughly tested. Feedback and results from community testing are welcome.

The training settings are experimental. Appropriate learning rates, training steps, timestep distribution, etc. are not yet fully determined. Feedback is welcome.

For additional options, use `python kandinsky5_train_network.py --help`.

### Key Options / 主要オプション

- `--task`: Model configuration (architecture, attention type, resolution, sampling parameters). See Available Tasks above.
- `--dit`: Path to DiT checkpoint. **Overrides the task's default checkpoint path.** You can use any compatible checkpoint (SFT, pretrain, or your own) with any task config as long as the architecture matches.
- `--vae`: Path to VAE checkpoint (overrides task default)
- `--network_module`: Use `networks.lora_kandinsky` for Kandinsky5 LoRA

**Note**: The `--task` option only sets the model architecture and parameters, not the weights. Use `--dit` to specify which checkpoint to load.

**注意**: `--task`オプションはモデルのアーキテクチャとパラメータのみを設定し、重みは設定しません。`--dit`で読み込むチェックポイントを指定してください。

### Memory Optimization / メモリ最適化

`--gradient_checkpointing` enables gradient checkpointing to reduce VRAM usage.

`--fp8_base` runs DiT in fp8 mode. This can significantly reduce memory consumption but may impact output quality.

If you're running low on VRAM, use `--blocks_to_swap` to offload some blocks to CPU.

`--gradient_checkpointing_cpu_offload` can be used to offload activations to CPU when using gradient checkpointing. This must be used together with `--gradient_checkpointing`.

### Attention / アテンション

Use `--sdpa`, `--flash_attn`, `--flash3`, `--sage_attn`, or `--xformers` to control the attention backend for Kandinsky5.

### Kandinsky5-specific Options / Kandinsky5固有オプション

- `--scheduler_scale`: Overrides the task's scheduler scaling factor. This affects the timestep schedule used in sampling/inference and is also stored in the task config used during training.
- `--offload_dit_during_sampling`: Offloads the DiT model to CPU during sampling (sample generation during training, and in `kandinsky5_generate_video.py`) to reduce peak VRAM usage.
- `--i` / `--image`: Init image path for i2v-style seeding in `kandinsky5_generate_video.py`.

**NABLA attention (training):**

- `--force_nabla_attention`: Force NABLA attention regardless of the task default.
- `--nabla_method`: NABLA binarization method (default `topcdf`).
- `--nabla_P`: CDF threshold (default `0.9`).
- `--nabla_wT`, `--nabla_wH`, `--nabla_wW`: STA window sizes (defaults `11`, `3`, `3`).
- `--nabla_add_sta` / `--no_nabla_add_sta`: Enable/disable STA prior when forcing NABLA.

**NABLA-compatible latent caching:**

- `kandinsky5_cache_latents.py --nabla_resize`: Resizes inputs to the next multiple of 128 before VAE encoding, which helps produce latents compatible with NABLA geometry constraints.

### Sample Generation During Training / 学習中のサンプル生成

Sample generation during training is supported. See [sampling during training](./sampling_during_training.md) for details.

<details>
<summary>日本語</summary>

上のコマンド例を使用して学習を開始してください（実際には一行で入力）。

日本語セクションの例（英語セクションと同じ内容）：

```bash
accelerate launch --num_cpu_threads_per_process 1 --mixed_precision bf16 \
    kandinsky5_train_network.py \
    --mixed_precision bf16 \
    --dataset_config path/to/dataset.toml \
    --task k5-pro-t2v-5s-sd \
    --dit path/to/kandinsky5pro_t2v_pretrain_5s.safetensors \
    --text_encoder_qwen Qwen/Qwen2.5-VL-7B-Instruct \
    --text_encoder_clip openai/clip-vit-large-patch14 \
    --vae path/to/vae/diffusion_pytorch_model.safetensors \
    --fp8_base \
    --sdpa \
    --gradient_checkpointing \
    --max_data_loader_n_workers 1 \
    --persistent_data_loader_workers \
    --learning_rate 1e-4 \
    --optimizer_type AdamW8Bit \
    --optimizer_args "weight_decay=0.001" "betas=(0.9,0.95)" \
    --max_grad_norm 1.0 \
    --lr_scheduler constant_with_warmup \
    --lr_warmup_steps 100 \
    --network_module networks.lora_kandinsky \
    --network_dim 32 \
    --network_alpha 32 \
    --timestep_sampling shift \
    --discrete_flow_shift 5.0 \
    --output_dir path/to/output \
    --output_name k5_lora \
    --save_every_n_epochs 1 \
    --max_train_epochs 50 \
    --scheduler_scale 10.0
```

I2Vの学習を行う場合は、タスクとチェックポイントをI2V向けプリセットに変更してください（例: `k5-pro-i2v-5s-sd` と `kandinsky5pro_i2v_sft_5s.safetensors`）。`kandinsky5_cache_latents.py` でlatentをキャッシュする際に、最初のフレームlatent（`latents_image`）も保存されるため、I2V専用の追加フラグは不要です（I2Vタスクを選ぶだけで動作します）。

**最初と最後のフレーム条件付けについて**: 最初と最後のフレーム学習サポートは実験的なものです。このアプローチの有効性と妥当性はまだ十分にテストされていません。コミュニティからのフィードバックと結果をお待ちしています。

学習設定は実験的なものです。適切な学習率、学習ステップ数、タイムステップの分布などは、まだ完全には決まっていません。フィードバックをお待ちしています。

その他のオプションは `--help` で確認できます。

**主要オプション**

- `--task`: モデル設定（上記の利用可能なタスクを参照）
- `--dit`: DiTチェックポイントへのパス（タスクのデフォルトを上書き）
- `--vae`: VAEチェックポイントへのパス（タスクのデフォルトを上書き）
- `--network_module`: Kandinsky5 LoRAには `networks.lora_kandinsky` を使用

**メモリ最適化**

`--gradient_checkpointing`でgradient checkpointingを有効にし、VRAM使用量を削減できます。

`--fp8_base`を指定すると、DiTがfp8で学習されます。消費メモリを大きく削減できますが、品質は低下する可能性があります。

VRAMが足りない場合は、`--blocks_to_swap`を指定して、一部のブロックをCPUにオフロードしてください。

`--gradient_checkpointing_cpu_offload`を指定すると、gradient checkpointing使用時にアクティベーションをCPUにオフロードします。`--gradient_checkpointing`と併用する必要があります。

**アテンション**

`--sdpa`/`--flash_attn`/`--flash3`/`--sage_attn`/`--xformers`はKandinsky5のattention backendに適用されます。

**Kandinsky5固有オプション**

- `--scheduler_scale`: タスクの`scheduler_scale`を上書きします。サンプリング/推論で使うタイムステップスケジュールに影響します。
- `--offload_dit_during_sampling`: サンプル生成時（学習中のサンプリング、および `kandinsky5_generate_video.py`）にDiTをCPUへ退避し、ピークVRAMを下げます。
- `--i` / `--image`: `kandinsky5_generate_video.py` でi2v風の初期画像（1フレーム目のシード）を指定します。

**NABLAアテンション（学習）**

- `--force_nabla_attention`: タスク設定に関係なくNABLAを強制します。
- `--nabla_method`: NABLAの二値化メソッド（デフォルト `topcdf`）。
- `--nabla_P`: CDFしきい値（デフォルト `0.9`）。
- `--nabla_wT`, `--nabla_wH`, `--nabla_wW`: STAウィンドウ（デフォルト `11`, `3`, `3`）。
- `--nabla_add_sta` / `--no_nabla_add_sta`: STA priorの有効/無効。

**NABLA互換latentキャッシュ**

- `kandinsky5_cache_latents.py --nabla_resize`: VAEエンコード前に入力を128の倍数へリサイズし、NABLAの幾何条件に合うlatentを生成しやすくします。

**学習中のサンプル生成**

学習中のサンプル生成がサポートされています。詳細は[学習中のサンプリング](./sampling_during_training.md)を参照してください。

</details>

## Inference / 推論

Generate videos using the following command:

```bash
python kandinsky5_generate_video.py \
    --task k5-pro-t2v-5s-sd \
    --dit path/to/kandinsky5pro_t2v_pretrain_5s.safetensors \
    --vae path/to/vae/diffusion_pytorch_model.safetensors \
    --text_encoder_qwen Qwen/Qwen2.5-VL-7B-Instruct \
    --text_encoder_clip openai/clip-vit-large-patch14 \
    --offload_dit_during_sampling \
    --fp8_base \
    --dtype bfloat16 \
    --prompt "A cat walks on the grass, realistic style." \
    --negative_prompt "low quality, artifacts" \
    --frames 17 \
    --steps 50 \
    --guidance 5 \
    --scheduler_scale 10 \
    --seed 42 \
    --width 512 \
    --height 512 \
    --output path/to/output.mp4 \
    --lora_weight path/to/lora.safetensors \
    --lora_multiplier 1.0
```

### Options / オプション

- `--task`: Model configuration
- `--prompt`: Text prompt for generation
- `--negative_prompt`: Negative prompt (optional)
- `--output`: Output file path (.mp4 for video, .png for image)
- `--width`, `--height`: Output resolution (defaults from task config)
- `--frames`: Number of frames (defaults from task config)
- `--steps`: Number of inference steps (defaults from task config)
- `--guidance`: Guidance scale (defaults from task config)
- `--seed`: Random seed
- `--fp8_base`: Run DiT in fp8 mode
- `--blocks_to_swap`: Number of blocks to offload to CPU
- `--lora_weight`: Path(s) to LoRA weight file(s)
- `--lora_multiplier`: LoRA multiplier(s)

For additional options, use `python kandinsky5_generate_video.py --help`.

<details>
<summary>日本語</summary>

上のコマンド例を使用して動画を生成します。

**オプション**

- `--task`: モデル設定
- `--prompt`: 生成用のテキストプロンプト
- `--negative_prompt`: ネガティブプロンプト（オプション）
- `--output`: 出力ファイルパス（動画は.mp4、画像は.png）
- `--width`, `--height`: 出力解像度（タスク設定からのデフォルト）
- `--frames`: フレーム数（タスク設定からのデフォルト）
- `--steps`: 推論ステップ数（タスク設定からのデフォルト）
- `--guidance`: ガイダンススケール（タスク設定からのデフォルト）
- `--seed`: ランダムシード
- `--fp8_base`: DiTをfp8モードで実行
- `--blocks_to_swap`: CPUにオフロードするブロック数
- `--lora_weight`: LoRA重みファイルへのパス
- `--lora_multiplier`: LoRA係数

その他のオプションは `--help` で確認できます。

</details>

## Dataset Configuration / データセット設定

Dataset configuration is the same as other architectures. See [dataset configuration](./dataset_config.md) for details.

<details>
<summary>日本語</summary>

データセット設定は他のアーキテクチャと同じです。詳細は[データセット設定](./dataset_config.md)を参照してください。

</details>
