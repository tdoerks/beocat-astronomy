#!/bin/bash
#SBATCH --job-name=tess_phase3c_more_random
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase3c_more_random_%j.out
#SBATCH --error=logs/phase3c_more_random_%j.err

# PHASE 3C: Download MORE Random TESS Stars for Discovery
# Continue building random star sample with different seed
# Goal: Get another ~500 stars to reach ~1,000 total

echo "=========================================="
echo "PHASE 3C: More Random Stars (seed=2025)"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo ""
echo "Building on Phase 3 v2 success (529 stars)"
echo "Using different random seed for NEW random sample"
echo "Expected hit rate: ~10% (based on Phase 3 v2)"
echo "Target: 500 more stars → ~1,000 total"
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
mkdir -p ../data/tess_random_batch2

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run random download script with DIFFERENT seed
echo "Downloading 500 MORE random TESS stars..."
echo "Using seed=2025 (different from Phase 3 v2 seed=42)"
echo "This will search ~5,000 TIC IDs to find ~500 with data"
echo "Saving to: ../data/tess_random_batch2/"
echo ""

python download_tess_random.py -n 500 -o ../data/tess_random_batch2 -s 2025

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_random_batch2/"
echo ""
echo "Total random stars collected:"
echo "  Phase 3 v2: 529 stars (../data/tess_random/)"
echo "  Phase 3c: $(ls -1 ../data/tess_random_batch2/*.fits 2>/dev/null | wc -l) stars (../data/tess_random_batch2/)"
echo "  TOTAL: $((529 + $(ls -1 ../data/tess_random_batch2/*.fits 2>/dev/null | wc -l))) stars!"
