# Installation commands

conda create -n MuseTalk python==3.10 -y
conda run -n MuseTalk pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118
conda run -n MuseTalk pip install -r requirements.txt
conda run -n MuseTalk pip install pip install decord
conda run -n MuseTalk pip install --no-cache-dir -U openmim
conda run -n MuseTalk mim install mmengine
conda run -n MuseTalk mim install "mmcv==2.0.1"
conda run -n MuseTalk mim install "mmdet==3.1.0"
conda run -n MuseTalk mim install "mmpose==1.1.0"
sudo sed -i '/bullseye-backports/d' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install ffmpeg -y
ffmpeg -version
sh ./download_weights.sh
hf download global-optima-research/HDTF --local-dir dataset/HDTF/source
unzip -o dataset/HDTF/source/clips.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/audios.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/audios_tiny.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/poses.zip -d dataset/HDTF/source/
unzip -o dataset/HDTF/source/videos.zip -d dataset/HDTF/source/

# Commands to run various things

We use conda in this project /opt/conda/envs/MuseTalk

/opt/conda/envs/MuseTalk/bin/python -m scripts.preprocess --config ./configs/training/preprocess_small.yaml
/opt/conda/envs/MuseTalk/bin/python -m scripts.preprocess --config ./configs/training/preprocess_small_test.yaml
/opt/conda/envs/MuseTalk/bin/accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage1.yaml 
/opt/conda/envs/MuseTalk/bin/accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage1.yaml >error_list.txt

# probably install tracker as well pip install wandb weave
# /opt/conda/envs/MuseTalk/bin/accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage1.yaml

/opt/conda/envs/MuseTalk/bin/accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage2.yaml

gemni


python -m scripts.realtime_inference --inference_config ./configs/inference/realtime_small.yaml --result_dir ./results/abrakadabra --unet_model_path ./models/musetalkV15/unet.pth --unet_config ./models/musetalkV15/musetalk.json --version v15 --fps 25 --version v15