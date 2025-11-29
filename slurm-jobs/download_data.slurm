#!/bin/bash
#SBATCH --job-name=tess_download
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=04:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/download_%j.out
#SBATCH --error=logs/download_%j.err

# PHASE 1: Download confirmed exoplanet host stars
# This job downloads 50 confirmed exoplanet light curves for pipeline validation

echo "=========================================="
echo "PHASE 1: Confirmed Exoplanet Download"
echo "=========================================="
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
cd $SLURM_SUBMIT_DIR/../scripts

# Run download script for 50 confirmed exoplanets
echo "Downloading 50 confirmed exoplanet host stars..."
python download_tess_data.py -n 50 -o ../data/tess

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess/"
