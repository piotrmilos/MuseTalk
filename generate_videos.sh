#!/bin/bash


OBSOLETE, now use generate_videos.py

# --- Configuration ---

# CHECKPOINT_DIR="/home/pmilos_google_com/MuseTalk/first_long_experiment/stage1/test"
CHECKPOINT_DIR="/home/pmilos_google_com/MuseTalk/exp_out/stage1/test"
# # CHECKPOINT_DIR="/home/pmilos_google_com/MuseTalk/exp_out/stage2/test"
# RESULT_DIR_BASE="/home/pmilos_google_com/MuseTalk/results/polished-elevator"
RESULT_DIR_BASE="/home/pmilos_google_com/MuseTalk/results/toasty-resonance"
RESULT_DIR_BASE="/home/pmilos_google_com/MuseTalk/results/sparkling-gorge"

: ${CHECKPOINT_DIR:?Warning: CHECKPOINT_DIR is not set or is empty. Exiting.}
: ${RESULT_DIR_BASE:?Warning: CHECKPOINT_DIR is not set or is empty. Exiting.}

# Find all .pth files, sort them numerically (for epochs), and loop through them
find "$CHECKPOINT_DIR" -name "*.pth" | sort -V | while read -r checkpoint_path; do
    
    # 1. Prepare variables for the current checkpoint
    checkpoint_name=$(basename "$checkpoint_path" .pth)
    result_dir="$RESULT_DIR_BASE/$checkpoint_name"

    # 2. Check if the output directory already exists
    if [ -d "$result_dir" ]; then
        echo "✅ Result directory already exists for checkpoint $checkpoint_name."
        echo "   Path: $result_dir"
        echo "   Skipping generation for this checkpoint."
        continue # Skip the rest of the loop for this checkpoint and move to the next
    fi

    # 3. If the directory does NOT exist, proceed with generation
    echo "⏳ Output directory $result_dir not found. Starting generation for checkpoint $checkpoint_name..."

    # Define the full command for clarity
    COMMAND="python -m scripts.realtime_inference \
        --inference_config ./configs/inference/realtime_small.yaml \
        --result_dir $result_dir \
        --unet_model_path $checkpoint_path \
        --unet_config ./models/musetalkV15/musetalk.json \
        --version v15 \
        --fps 25"
    
    # Print the command being executed (optional, but helpful for debugging)
    echo "Executing: $COMMAND"

    # Execute the command
    python -m scripts.realtime_inference --inference_config ./configs/inference/realtime_small.yaml --result_dir "$result_dir" --unet_model_path "$checkpoint_path" --unet_config ./models/musetalkV15/musetalk.json --version v15 --fps 25
    
    echo "--- Finished generation for $checkpoint_name ---"
done
sleep 600
echo "Script finished processing all checkpoints."