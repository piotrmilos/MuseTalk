# MuseTalk Installation Plan

This document outlines the steps to install MuseTalk. Can be executed with gemini-cli.

## 1. Environment Setup

First, create and activate a conda environment with Python 3.10.

```bash
conda create -n MuseTalk python==3.10
conda activate MuseTalk
```

Use this env afterwards.

## 2. Install PyTorch

Install PyTorch 2.0.1 and associated packages using pip.

```bash
pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118
```

## 3. Install Dependencies from requirements.txt

Install the packages listed in the `requirements.txt` file.

```bash
pip install -r requirements.txt
```

## 4. Install MMLab Packages

Install the required MMLab packages using `mim`.

```bash
pip install --no-cache-dir -U openmim
mim install mmengine
mim install "mmcv==2.0.1"
mim install "mmdet==3.1.0"
mim install "mmpose==1.1.0"
```

## 5. Install FFmpeg

On gLinux, you can install FFmpeg using the system package manager.

```bash
sudo apt-get update
sudo apt-get install ffmpeg
```
After installation, verify it's correctly installed and available in your PATH:
```bash
ffmpeg -version
```

## 6. Download Model Weights

Download the pretrained model weights using the provided shell script.

```bash
sh ./download_weights.sh
```
This will download and place all the necessary model files into the `./models/` directory with the correct structure.

## 7. Dataset download

Download dataset from https://huggingface.co/datasets/global-optima-research/HDTF and place it in dataset/HDTF/source
Extract zips.

## 8. Data Preprocessing

Run the preprocessing script to prepare the dataset for training.

```bash
python -m scripts.preprocess --config ./configs/training/preprocess.yaml
```

If you encounter a `ModuleNotFoundError` for `decord`, install it with:
```bash
pip install decord
```
Note that decord is removed except from preprocessing.


## 9. Perhpas install experiment tracker
ask the user or the key and put it pernamently to .bashrc (or where is appropriate)
pip install wandb weave