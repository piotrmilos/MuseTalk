#!/usr/bin/env python3
import subprocess
import re
from pathlib import Path

CHECKPOINT_DIR = "/home/pmilos_google_com/MuseTalk/exp_out/"
RESULT_DIR_BASE = "/home/pmilos_google_com/MuseTalk/results"

def natural_sort_key(s):
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split(r'(\d+)', str(s))]

def main():
    checkpoint_base = Path(CHECKPOINT_DIR)
    result_base = Path(RESULT_DIR_BASE)
    
    checkpoints = sorted(checkpoint_base.rglob("*.pth"), key=lambda p: natural_sort_key(p.name))

    for checkpoint_path in checkpoints:
        relative_path = checkpoint_path.relative_to(checkpoint_base)
        relative_dir = relative_path.with_suffix('')
        result_dir = result_base / relative_dir

        if result_dir.is_dir():
            print(f" Result directory already exists for checkpoint {checkpoint_path}.")
            print("   Skipping generation for this checkpoint.")
            continue

        print(f" Output directory {result_dir} not found. Starting generation for checkpoint {checkpoint_path}...")

        command = [
            "python", "-m", "scripts.realtime_inference",
            "--inference_config", "./configs/inference/realtime_full_eval.yaml",
            "--result_dir", str(result_dir),
            "--unet_model_path", str(checkpoint_path),
            "--unet_config", "./models/musetalkV15/musetalk.json",
            "--version", "v15",
            "--fps", "25"
        ]

        print(f"Executing: {' '.join(command)}")

        try:
            subprocess.run(command, check=True)
            print(f"--- Finished generation for {checkpoint_path} ---")
        except subprocess.CalledProcessError as e:
            print(f"❌ Error occurred while processing {checkpoint_path}: {e}")

    print("Script finished processing all checkpoints.")

if __name__ == "__main__":
    main()