#!/bin/bash
#SBATCH --job-name=tess_analyze_phase2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH --mem=32G
#SBATCH --output=logs/analyze_phase2_%j.out
#SBATCH --error=logs/analyze_phase2_%j.err

# PHASE 2 ANALYSIS: Analyze 196 TOI candidate light curves
# Helps validate unconfirmed exoplanet candidates!

echo "=========================================="
echo "PHASE 2: TOI Candidate Analysis"
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
mkdir -p ../results/phase2_toi

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/../scripts

# Run analysis script on Phase 2 TOI data
echo "Analyzing 196 TOI candidate light curves..."
echo "This will take longer - analyzing ~6x more targets than Phase 1"
echo ""

python analyze_tess_transits.py -d ../data/tess_toi -o ../results/phase2_toi

echo ""
echo "Job finished: $(date)"
echo "Results saved to: ../results/phase2_toi/"
echo ""
echo "Check analysis_summary.txt for detected transit signals!"
echo "Strong signals in TOI candidates = confirmed exoplanets!"
