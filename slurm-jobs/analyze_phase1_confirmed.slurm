#!/bin/bash
#SBATCH --job-name=tess_analyze_phase1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase1_%j.out
#SBATCH --error=logs/analyze_phase1_%j.err

# PHASE 1 ANALYSIS: Analyze 33 confirmed exoplanet light curves
# This validates the pipeline at scale

echo "=========================================="
echo "PHASE 1: Confirmed Exoplanet Analysis"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_PER_TASK"
echo ""

# Load modules
module load Python/3.9

# Activate astronomy environment
source $HOME/astro_env/bin/activate

# Create directories if they don't exist
mkdir -p logs
mkdir -p ../results/phase1_confirmed

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run analysis script on Phase 1 data
echo "Analyzing 33 confirmed exoplanet light curves..."
python analyze_tess_transits.py -d ../data/tess -o ../results/phase1_confirmed

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../results/phase1_confirmed/"
