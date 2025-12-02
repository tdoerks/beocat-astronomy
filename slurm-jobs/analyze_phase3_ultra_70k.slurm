#!/bin/bash
#SBATCH --job-name=tess_analyze_phase3_ultra
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=168:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase3_ultra_%j.out
#SBATCH --error=logs/analyze_phase3_ultra_%j.err

# PHASE 3 ULTRA ANALYSIS: Analyze 70,000 random star light curves
# MASSIVE RANDOM EXOPLANET DISCOVERY SURVEY!
# This is the largest random TESS survey ever conducted by an individual!

echo "=========================================="
echo "PHASE 3 ULTRA: Analyzing 70,000 Random Stars!"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_PER_TASK"
echo ""
echo "DATASET: tess_random_ultra_70k/"
echo "TARGET: Up to 70,000 random TESS stars"
echo "PURPOSE: Largest random exoplanet discovery survey"
echo ""
echo "This is UNPRECEDENTED SCALE for amateur/small-team astronomy!"
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
mkdir -p ../results/phase3_ultra_analysis

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Count input files
NUM_FILES=$(ls -1 ../data/tess_random_ultra_70k/*.fits 2>/dev/null | wc -l)
echo "Input files found: $NUM_FILES"
echo ""

if [ "$NUM_FILES" -eq 0 ]; then
    echo "ERROR: No FITS files found in ../data/tess_random_ultra_70k/"
    echo "Make sure download job completed successfully"
    exit 1
fi

# Run analysis script on Phase 3 ULTRA random star data
echo "Analyzing $NUM_FILES random TESS star light curves..."
echo "This is ULTRA-SCALE DISCOVERY MODE - looking for NEW exoplanets!"
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
echo "Expected runtime: ~$(($NUM_FILES / 800)) hours at 800 stars/hour"
echo "Time limit: 7 days (very generous buffer)"
echo ""
echo "=========================================="
echo "STARTING ANALYSIS..."
echo "=========================================="
echo ""

python analyze_tess_transits.py -d ../data/tess_random_ultra_70k -o ../results/phase3_ultra_analysis

EXIT_CODE=$?

echo ""
echo "=========================================="
echo "Job finished: $(date)"
echo "Exit code: $EXIT_CODE"
echo "=========================================="
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ Analysis completed successfully!"
    echo ""
    echo "Results saved to: ../results/phase3_ultra_analysis/"
    echo ""
    echo "Quick stats:"
    ls -lh ../results/phase3_ultra_analysis/ 2>/dev/null | head -5
    echo ""
    echo "File count:"
    PLOT_COUNT=$(ls -1 ../results/phase3_ultra_analysis/*.png 2>/dev/null | wc -l)
    echo "$PLOT_COUNT PNG plots generated"
    echo ""
    echo "Analysis summary:"
    head -100 ../results/phase3_ultra_analysis/analysis_summary.txt 2>/dev/null
    echo ""
    echo "=========================================="
    echo "CHECK FOR DISCOVERIES! 🔭✨"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Run analyze_results.py to compile ALL results"
    echo "  2. Check top candidates (power > 10,000)"
    echo "  3. Visually inspect strongest signals"
    echo "  4. Cross-reference with TOI catalog"
    echo "  5. Update Zenodo dataset with FULL 75,000+ star survey!"
    echo ""
    echo "Combined dataset will be:"
    echo "  - Phase 3 original: 529 stars"
    echo "  - Phase 3 MEGA: 4,673 stars"
    echo "  - Phase 3 ULTRA: $NUM_FILES stars"
    echo "  - TOTAL: ~75,000+ random TESS stars!"
    echo ""
    echo "This is publication-worthy! 🚀🌟"
else
    echo "✗ Analysis failed with exit code $EXIT_CODE"
    echo "Check error log: logs/analyze_phase3_ultra_${SLURM_JOB_ID}.err"
fi

echo ""
echo "Happy planet hunting! 🪐"
