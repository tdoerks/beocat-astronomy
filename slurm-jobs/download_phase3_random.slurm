#!/bin/bash
#SBATCH --job-name=tess_phase3_random
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase3_random_%j.out
#SBATCH --error=logs/phase3_random_%j.err

# PHASE 3: Download Random TESS Stars for Discovery (FIXED!)
# Search for new/missed exoplanet transits
# NOW ACCEPTS FFI DATA (30-min cadence) - Much better hit rate!

echo "=========================================="
echo "PHASE 3: Random Star Search (v2 - Fixed!)"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo ""
echo "IMPROVEMENT: Now accepts both SPOC and FFI data"
echo "Expected hit rate: ~5-10% (was 0.04% with SPOC-only)"
echo "This means we should get 1,000 stars from ~10,000-20,000 searches"
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
mkdir -p ../data/tess_random

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run random download script (1000 stars)
# With FFI data included, we should get much better hit rate!
echo "Searching random TIC IDs for TESS observations (SPOC or FFI)..."
echo "Expecting to search ~10,000-20,000 TIC IDs to find 1,000 with data"
echo "This will take a few hours - more stars = more discovery potential!"
echo ""

python download_tess_random.py -n 1000 -o ../data/tess_random

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_random/"
