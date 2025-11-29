#!/bin/bash
#SBATCH --job-name=tess_phase2_toi
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=08:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase2_toi_%j.out
#SBATCH --error=logs/phase2_toi_%j.err

# PHASE 2: Download TOI (TESS Objects of Interest) Candidates
# These are unconfirmed exoplanet candidates that need validation

echo "=========================================="
echo "PHASE 2: TOI Candidate Download"
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

# Run TOI download script (200 candidates)
python download_tess_toi.py -n 200 -o ../data/tess_toi

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_toi/"
