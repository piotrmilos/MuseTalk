import wandb

# --- Configuration ---
ENTITY = "lyzell"  # User or Team name
PROJECT = "test"
MIN_STEPS = 50
DRY_RUN = False  # Keep True initially to test. Set to False to actually delete.
# ---------------------

api = wandb.Api()
runs = api.runs(f"{ENTITY}/{PROJECT}")

print(f"Checking runs in {ENTITY}/{PROJECT} with less than {MIN_STEPS} steps...")

count = 0
for run in runs:
    # history_steps maps to the number of logged history points.
    # You might also check run.summary.get('_step', 0) if you specifically mean global training steps.
    steps = run.lastHistoryStep

    # Handle runs that might have crashed immediately and have no steps logged
    if steps is None:
        steps = 0
    
    # print(run.name)

    if steps < MIN_STEPS:
        count += 1
        if DRY_RUN:
            print(f"[DRY RUN] Would delete: {run.name} (ID: {run.id}) | Steps: {steps}")
        else:
            print(f"Deleting: {run.name} (ID: {run.id}) | Steps: {steps}")
            try:
                run.delete()
            except Exception as e:
                print(f"Error deleting {run.id}: {e}")

if DRY_RUN:
    print(f"\n[DRY RUN COMPLETE] Found {count} runs to delete. Set DRY_RUN = False to execute.")
else:
    print(f"\nDeletion complete. Deleted {count} runs.")