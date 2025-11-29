#!/bin/bash
#SBATCH --job-name=tess_analysis
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analysis_%j.out
#SBATCH --error=logs/analysis_%j.err

# Analyze TESS light curves for exoplanet transits
# This job performs BLS periodogram analysis on all downloaded light curves

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
mkdir -p ../results

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run analysis script
python analyze_tess_transits.py -d ../data/tess -o ../results

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../results/"
