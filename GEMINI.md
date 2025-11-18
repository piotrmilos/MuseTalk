# Installation commands

Look into musetalk_install.sh

adding a tracker is recommended. For wandb it is enough to:
pip install wandb
wandb login

conda activate MuseTalk
# Commands to run various things

python -m scripts.preprocess --config ./configs/training/preprocess.yaml # <--- the actual preprocess, below small tests. This is a slow operation. @pmilos - describe it better
python -m scripts.preprocess --config ./configs/training/preprocess_small.yaml
python -m scripts.preprocess --config ./configs/training/preprocess_small_test.yaml

accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config=./configs/training/stage1.yaml output_dir=./exp_out/PUT_DIR_HERE # single GPU training
accelerate launch --config_file ./configs/training/gpu_no_deepspeed.yaml --main_process_port 29502 train.py --config=./configs/training/stage1.yaml # two gpus. 
accelerate launch --config_file ./configs/training/gpu.yaml --main_process_port 29502 train.py --config=./configs/training/stage1.yaml # deepspeed does not work at the moment

accelerate launch --config_file ./configs/training/gpu_3.yaml --main_process_port 29502 train.py --config ./configs/training/stage2.yaml # stage 2 training.


python -m scripts.realtime_inference --inference_config ./configs/inference/realtime_small.yaml --result_dir ./results/abrakadabra --unet_model_path ./models/musetalkV15/unet.pth --unet_config ./models/musetalkV15/musetalk.json --version v15 --fps 25 --version v15