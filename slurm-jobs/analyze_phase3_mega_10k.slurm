#!/bin/bash
#SBATCH --job-name=tess_analyze_phase3_mega
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=168:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase3_mega_%j.out
#SBATCH --error=logs/analyze_phase3_mega_%j.err

# PHASE 3 MEGA ANALYSIS: Analyze 4,674 random star light curves
# LARGE-SCALE DISCOVERY MODE - 10× larger sample than Phase 3!

echo "=========================================="
echo "PHASE 3 MEGA: Analyzing 4,674 Random Stars!"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_PER_TASK"
echo ""
echo "DATASET: tess_random_mega_10k/"
echo "TARGET: 4,674 random TESS stars"
echo "PURPOSE: Large-scale random exoplanet discovery survey"
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
mkdir -p ../results/phase3_mega_analysis

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Count input files
NUM_FILES=$(ls -1 ../data/tess_random_mega_10k/*.fits 2>/dev/null | wc -l)
echo "Input files found: $NUM_FILES"
echo ""

# Run analysis script on Phase 3 MEGA random star data
echo "Analyzing $NUM_FILES random TESS star light curves..."
echo "This is LARGE-SCALE DISCOVERY MODE - looking for NEW exoplanets!"
echo ""
echo "What to look for:"
echo "  - Strong transit signals (power > 1,000)"
echo "  - Periodic dips in brightness (0.5-20 day periods)"
echo "  - Clear transit shapes in phase-folded plots"
echo ""
echo "Expected output:"
echo "  - ~$(($NUM_FILES * 2)) plots (analysis + phase-folded)"
echo "  - CSV file with all detections"
echo "  - analysis_summary.txt with strongest signals"
echo ""
echo "Expected runtime: ~6 hours (at 800 stars/hour)"
echo "Time limit: 7 days (very generous buffer)"
echo ""
echo "Analysis starting..."
echo ""

python analyze_tess_transits.py -d ../data/tess_random_mega_10k -o ../results/phase3_mega_analysis

echo ""
echo "=========================================="
echo "Job finished: $(date)"
echo "=========================================="
echo "Results saved to: ../results/phase3_mega_analysis/"
echo ""
echo "Quick stats:"
ls -lh ../results/phase3_mega_analysis/ 2>/dev/null | head -5
echo ""
echo "File count:"
ls -1 ../results/phase3_mega_analysis/*.png 2>/dev/null | wc -l
echo "PNG plots generated"
echo ""
echo "=========================================="
echo "CHECK FOR DISCOVERIES! 🔭✨"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Check analysis_summary.txt for strongest signals"
echo "  2. Look for high transit power (> 1,000)"
echo "  3. Visually inspect top candidates"
echo "  4. Cross-reference with TOI catalog"
echo ""
echo "These are RANDOM stars - any strong transit could be:"
echo "  - Undiscovered exoplanet!"
echo "  - Eclipsing binary star"
echo "  - Known planet not yet in TOI catalog"
echo ""
echo "Happy planet hunting! 🪐"
