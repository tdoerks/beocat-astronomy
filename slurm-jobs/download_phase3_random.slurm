#!/bin/bash
#SBATCH --job-name=tess_phase3_random
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase3_random_%j.out
#SBATCH --error=logs/phase3_random_%j.err

# PHASE 3: Download Random TESS Stars for Discovery
# Search for new/missed exoplanet transits

echo "=========================================="
echo "PHASE 3: Random Star Search"
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

# Run random download script (1000 stars)
# Note: This searches 5000 random TIC IDs to find 1000 with TESS data
echo "Searching random TIC IDs for TESS observations..."
echo "This may take several hours as most random stars don't have TESS data"
echo ""

python download_tess_random.py -n 1000 -o ../data/tess_random

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_random/"
