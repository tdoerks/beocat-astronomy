#!/bin/bash
#SBATCH --job-name=tess_phase2b_all_tois_download
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase2b_all_tois_download_%j.out
#SBATCH --error=logs/phase2b_all_tois_download_%j.err

# PHASE 2B: Download ALL ~7,000 TOI (TESS Objects of Interest) Candidates
# This is the FULL TOI catalog - comprehensive exoplanet candidate validation!

echo "=========================================="
echo "PHASE 2B: Full TOI Catalog Download"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Target: ALL ~7,000 TOI candidates"
echo ""

# Load modules
module load Python/3.9

# Activate astronomy environment
ASTRO_ENV="/homes/tylerdoe/astro_env"
if [ ! -d "$ASTRO_ENV" ]; then
    echo "ERROR: Astronomy environment not found at $ASTRO_ENV"
    echo "Run: bash scripts/setup_beocat_env.sh"
    exit 1
fi

echo "Activating environment: $ASTRO_ENV"
source $ASTRO_ENV/bin/activate

# Verify lightkurve is available
python -c "import lightkurve" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: lightkurve not found in environment"
    echo "Run: pip install lightkurve"
    exit 1
fi

echo "Environment ready - lightkurve loaded"
echo ""

# Create directories if they don't exist
mkdir -p logs
mkdir -p ../data/tess_toi_full

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run TOI download script for ALL ~7,000 TOIs
echo "Downloading ALL ~7,000 TOI candidates from TESS catalog..."
echo "This will take several hours - searching TOI-1 through TOI-7499"
echo "Expected success rate: ~90% (based on Phase 2 results)"
echo ""

python download_tess_toi.py -n 7000 -o ../data/tess_toi_full

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_toi_full/"
echo ""
echo "Next step: Run analyze_phase2b_all_tois.slurm to analyze downloaded data!"
