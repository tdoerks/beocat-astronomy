#!/bin/bash
#SBATCH --job-name=tess_phase3_ultra_70k
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=168:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/phase3_ultra_70k_%j.out
#SBATCH --error=logs/phase3_ultra_70k_%j.err

# PHASE 3 ULTRA: Download 70,000 Random TESS Stars!
# 1-week job - MASSIVE random star discovery survey!
# This will be the LARGEST random TESS transit search ever!

echo "=========================================="
echo "PHASE 3 ULTRA: 70,000 Random Stars!"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo ""
echo "TARGET: 70,000 random TESS stars"
echo "EXPECTED: Search ~700,000 TIC IDs at 10% hit rate"
echo "STORAGE: ~70 GB data + ~70 GB results = ~140 GB total"
echo "MEMORY: 32 GB (increased from 8 GB to handle large downloads)"
echo "TIME: 7 days (168 hours)"
echo ""
echo "This is UNPRECEDENTED - largest random TESS survey!"
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
mkdir -p ../data/tess_random_ultra_70k

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run random download script - 70,000 stars!
echo "Downloading 70,000 random TESS stars..."
echo "Using seed=7777 for ultra random sample"
echo "This will search ~700,000 TIC IDs"
echo "Saving to: ../data/tess_random_ultra_70k/"
echo ""
echo "This is a 7-DAY MARATHON job!"
echo "Expected progress:"
echo "  - Day 1: ~10,000 stars"
echo "  - Day 3: ~30,000 stars"
echo "  - Day 5: ~50,000 stars"
echo "  - Day 7: ~70,000 stars COMPLETE!"
echo ""

python download_tess_random.py -n 70000 -o ../data/tess_random_ultra_70k -s 7777

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_random_ultra_70k/"
echo ""
echo "=========================================="
echo "ULTRA RANDOM SAMPLE COMPLETE!"
echo "=========================================="
echo ""
echo "Downloaded: $(ls -1 ../data/tess_random_ultra_70k/*.fits 2>/dev/null | wc -l) random TESS stars"
echo "Storage used: $(du -sh ../data/tess_random_ultra_70k/ | cut -f1)"
echo ""
echo "This is the LARGEST random TESS star sample ever analyzed!"
echo "Potential for MAJOR exoplanet discoveries! 🌍✨"
echo ""
echo "Next: Analyze all 70,000 stars for transit signals!"
