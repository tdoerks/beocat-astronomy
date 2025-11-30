#!/bin/bash
#SBATCH --job-name=tess_phase3_mega_10k
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --output=logs/phase3_mega_10k_%j.out
#SBATCH --error=logs/phase3_mega_10k_%j.err

# PHASE 3 MEGA: Download 10,000 Random TESS Stars!
# With 1TB /homes space, we can go BIG for discovery mode!

echo "=========================================="
echo "PHASE 3 MEGA: 10,000 Random Stars!"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo ""
echo "TARGET: 10,000 random TESS stars"
echo "EXPECTED: Search ~100,000 TIC IDs at 10% hit rate"
echo "STORAGE: ~10 GB data + ~10 GB results = ~20 GB total"
echo "TIME: ~20-24 hours (searching 100k TIC IDs)"
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
mkdir -p ../data/tess_random_mega_10k

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run random download script - 10,000 stars!
echo "Downloading 10,000 random TESS stars..."
echo "Using seed=9999 for mega random sample"
echo "This will search ~100,000 TIC IDs"
echo "Saving to: ../data/tess_random_mega_10k/"
echo ""
echo "This is a MARATHON job - will run for ~20-24 hours"
echo "Perfect for overnight + all day Sunday!"
echo ""

python download_tess_random.py -n 10000 -o ../data/tess_random_mega_10k -s 9999

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../data/tess_random_mega_10k/"
echo ""
echo "=========================================="
echo "MEGA RANDOM SAMPLE COMPLETE!"
echo "=========================================="
echo ""
echo "Downloaded: $(ls -1 ../data/tess_random_mega_10k/*.fits 2>/dev/null | wc -l) random TESS stars"
echo "Storage used: $(du -sh ../data/tess_random_mega_10k/ | cut -f1)"
echo ""
echo "This is the LARGEST random TESS star sample for exoplanet discovery!"
echo "Next: Analyze all 10,000 stars for transit signals! 🔭✨"
