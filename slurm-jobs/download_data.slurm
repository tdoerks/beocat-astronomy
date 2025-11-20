#!/bin/bash
#SBATCH --job-name=tess_download
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=04:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/download_%j.out
#SBATCH --error=logs/download_%j.err

# Download TESS data using lightkurve
# This job downloads light curves for analysis

echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo ""

# Load modules
module load Python/3.9

# Activate astronomy environment
source $HOME/astro_env/bin/activate

# Create logs directory if it doesn't exist
mkdir -p logs

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/scripts

# Run download script
# Adjust -n parameter to download more/fewer targets
python download_tess_data.py -n 10 -o ../data/tess

echo ""
echo "Job finished: $(date)"
