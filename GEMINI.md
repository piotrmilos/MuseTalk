# Installation commands

Look into musetalk_install.sh

adding a tracker is recommended. For wandb it is enough to:
pip install wandb
wandb login

# Commands to run various things

python -m scripts.preprocess --config ./configs/training/preprocess.yaml <--- the actual preprocess, below small tests. This is a slow operation.
python -m scripts.preprocess --config ./configs/training/preprocess_small.yaml
python -m scripts.preprocess --config ./configs/training/preprocess_small_test.yaml
accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage1.yaml 

# /opt/conda/envs/MuseTalk/bin/accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage1.yaml

accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage2.yaml


python -m scripts.realtime_inference --inference_config ./configs/inference/realtime_small.yaml --result_dir ./results/abrakadabra --unet_model_path ./models/musetalkV15/unet.pth --unet_config ./models/musetalkV15/musetalk.json --version v15 --fps 25 --version v15