#!/bin/bash
#SBATCH --job-name=tess_analyze_phase3_random
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase3_random_%j.out
#SBATCH --error=logs/analyze_phase3_random_%j.err

# PHASE 3 ANALYSIS: Analyze 529 random star light curves
# DISCOVERY MODE - Any strong transit signals = potential NEW exoplanets!

echo "=========================================="
echo "PHASE 3: Random Star Analysis (Discovery Mode!)"
echo "=========================================="
echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_PER_TASK"
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
mkdir -p ../results/phase3_random

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run analysis script on Phase 3 random star data
echo "Analyzing 529 random TESS star light curves..."
echo "This is DISCOVERY MODE - looking for NEW exoplanets!"
echo ""
echo "What to look for:"
echo "  - Strong transit signals (power > 1,000)"
echo "  - Periodic dips in brightness"
echo "  - Planets with periods 0.5-20 days"
echo ""
echo "Expected runtime: ~45 minutes (based on Phase 2 rate)"
echo ""

python analyze_tess_transits.py -d ../data/tess_random -o ../results/phase3_random

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../results/phase3_random/"
echo ""
echo "=========================================="
echo "CHECK FOR DISCOVERIES!"
echo "=========================================="
echo ""
echo "Review analysis_summary.txt for strong signals:"
echo "  - High transit power (> 1,000) = potential exoplanet!"
echo "  - Unknown star with clear transits = NEW DISCOVERY!"
echo ""
echo "These are RANDOM stars - any transit = potentially undiscovered planet!"
echo "Check plots visually for convincing transit signatures! 🔭✨"
