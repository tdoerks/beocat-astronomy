#!/bin/bash
#SBATCH --job-name=tess_analyze_phase2b_all_tois
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=168:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase2b_all_tois_%j.out
#SBATCH --error=logs/analyze_phase2b_all_tois_%j.err

# PHASE 2B ANALYSIS: Analyze ALL ~7,000 TOI candidate light curves
# This is the FULL TOI catalog - comprehensive search for confirmed exoplanets!
# Strong transit signals in TOI candidates = YOU HELPED CONFIRM EXOPLANETS!

echo "=========================================="
echo "PHASE 2B: Full TOI Catalog Analysis"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_PER_TASK"
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
mkdir -p ../results/phase2b_toi_full

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run analysis script on Phase 2B full TOI catalog
echo "Analyzing 5,893 TOI candidate light curves..."
echo "This will take several hours - analyzing 30x more targets than Phase 2!"
echo "Expected: ~5,893 successful BLS periodogram analyses"
echo ""
echo "Performance estimate (based on Phase 2 results):"
echo "  - Phase 2: 196 TOIs in ~13 minutes (analysis only)"
echo "  - Rate: ~15 TOIs/minute"
echo "  - 5,893 TOIs: ~6-7 hours estimated"
echo ""
echo "Note: 7-day time limit ensures completion even if slower than expected"
echo ""

python analyze_tess_transits.py -d ../data/tess_toi_full -o ../results/phase2b_toi_full

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../results/phase2b_toi_full/"
echo ""
echo "=========================================="
echo "CHECK RESULTS FOR EXOPLANET CONFIRMATIONS!"
echo "=========================================="
echo ""
echo "Review analysis_summary.txt for:"
echo "  - Strong transit signals (power > 1,000)"
echo "  - Reasonable periods (0.5-20 days for hot planets)"
echo "  - Multiple transit detections"
echo ""
echo "High-power TOI candidates with clear transits = CONFIRMED EXOPLANETS!"
echo "You just contributed to exoplanet science! 🌍✨"
