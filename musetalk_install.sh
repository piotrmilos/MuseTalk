#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# 1. Install system dependencies
echo "Installing system dependencies..."
sudo apt-get update && \
sudo apt-get install -y git wget ffmpeg unzip curl

# 2. Install Miniconda globally
echo "Installing Miniconda..."
if [ -d "$HOME/miniconda" ]; then
    echo "Miniconda already installed in $HOME/miniconda."
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda
    rm miniconda.sh
fi

# Add conda to PATH for this script
export PATH="$HOME/miniconda/bin:$PATH"

# 3. Clone the MuseTalk repository
echo "Cloning the MuseTalk repository..."
if [ ! -d "MuseTalk" ]; then
  git clone https://github.com/piotrmilos/MuseTalk.git
fi
cd MuseTalk
git checkout oom-sandbox

# 4. Create and activate conda environment
echo "Creating conda environment..."
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda create -n MuseTalk python==3.10 -y

# Activate the environment for subsequent commands
eval "$(conda shell.bash hook)"
conda activate MuseTalk

# 5. Install Python dependencies
echo "Installing Python dependencies..."
pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118
pip install -r requirements.txt
pip install  decord
pip install  -U openmim
pip install  "huggingface_hub[cli]" gdown
pip install huggingface_hub
mim install mmengine
mim install "mmcv==2.0.1"
mim install "mmdet==3.1.0"
pip install --no-build-isolation "chumpy==0.70"
mim install "mmpose==1.1.0"

# 6. Download weights
echo "Downloading models..."
mkdir -p models/musetalk models/musetalkV15 models/syncnet models/dwpose models/face-parse-bisent models/sd-vae models/whisper

export HF_ENDPOINT=https://hf-mirror.com

huggingface-cli download TMElyralab/MuseTalk --local-dir models --include "musetalk/musetalk.json" "musetalk/pytorch_model.bin" && \
huggingface-cli download TMElyralab/MuseTalk --local-dir models --include "musetalkV15/musetalk.json" "musetalkV15/unet.pth" && \
huggingface-cli download stabilityai/sd-vae-ft-mse --local-dir models/sd-vae --include "config.json" "diffusion_pytorch_model.bin" && \
huggingface-cli download openai/whisper-tiny --local-dir models/whisper --include "config.json" "pytorch_model.bin" "preprocessor_config.json" && \
huggingface-cli download yzd-v/DWPose --local-dir models/dwpose --include "dw-ll_ucoco_384.pth" && \
huggingface-cli download ByteDance/LatentSync --local-dir models/syncnet --include "latentsync_syncnet.pt"


# 7. Download and extract dataset
echo "Downloading and extracting dataset..."
huggingface-cli download global-optima-research/HDTF --repo-type dataset --local-dir dataset/HDTF/source
unzip -o dataset/HDTF/source/clips.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/audios.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/audios_tiny.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/poses.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/videos.zip -d dataset/HDTF/source/

echo "Installation complete."
echo "To use MuseTalk, activate the conda environment:"
echo "cd MuseTalk"
echo 'eval "$(conda shell.bash hook)"'
echo "conda activate MuseTalk"