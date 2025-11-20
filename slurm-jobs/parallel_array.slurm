#!/bin/bash
#SBATCH --job-name=tess_array
#SBATCH --array=1-10
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=06:00:00
#SBATCH --mem=16G
#SBATCH --output=logs/array_%A_%a.out
#SBATCH --error=logs/array_%A_%a.err

# Array job template for parallel processing
# This processes multiple targets simultaneously
# Each array task processes a different subset of data

echo "Job array started: $(date)"
echo "Array Task ID: $SLURM_ARRAY_TASK_ID"
echo "Running on node: $(hostname)"
echo ""

# Load modules
module load Python/3.9

# Activate astronomy environment
source $HOME/astro_env/bin/activate

# Create logs directory
mkdir -p logs

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/scripts

# Example: Process a subset of targets based on array task ID
# This allows parallel processing of large datasets
# Modify this to match your data structure

START_IDX=$(( ($SLURM_ARRAY_TASK_ID - 1) * 100 ))
END_IDX=$(( $SLURM_ARRAY_TASK_ID * 100 ))

echo "Processing targets $START_IDX to $END_IDX"

# Replace with your parallel processing script
# python process_batch.py --start $START_IDX --end $END_IDX

echo ""
echo "Task finished: $(date)"
