#!/bin/bash
#SBATCH --job-name=tess_homes_test
#SBATCH --output=/homes/tylerdoe/slurm_tess_test_%j.out
#SBATCH --error=/homes/tylerdoe/slurm_tess_test_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=tdoerks@vet.k-state.edu

echo "=========================================="
echo "TESS Exoplanet Pipeline - Test from /homes"
echo "Running while /fastscratch is unavailable"
echo "=========================================="
echo "Job ID: $SLURM_JOB_ID"
echo "Start time: $(date)"
echo "Hostname: $(hostname)"
echo "CPUs: $SLURM_CPUS_PER_TASK"
echo ""

# Navigate to project directory in homes
PROJECT_DIR="/homes/tylerdoe/beocat-astronomy"
cd $PROJECT_DIR || {
    echo "ERROR: Cannot access $PROJECT_DIR"
    echo "Please clone the repository first:"
    echo "  cd /homes/tylerdoe"
    echo "  git clone https://github.com/tdoerks/beocat-astronomy.git"
    exit 1
}

echo "Project directory: $(pwd)"
echo ""

# Load Python module
echo "Loading Python module..."
module load Python/3.9

# Check if virtual environment exists
ASTRO_ENV="$HOME/astro_env"
if [ ! -d "$ASTRO_ENV" ]; then
    echo "WARNING: Virtual environment not found at $ASTRO_ENV"
    echo "Setting up astronomy environment (first time only)..."
    echo ""

    # Run setup script
    bash scripts/setup_beocat_env.sh

    if [ $? -ne 0 ]; then
        echo "ERROR: Environment setup failed"
        exit 1
    fi
else
    echo "Using existing environment at $ASTRO_ENV"
fi

# Activate environment
echo "Activating astronomy environment..."
source $ASTRO_ENV/bin/activate

# Verify lightkurve is installed
python -c "import lightkurve" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: lightkurve not installed in environment"
    echo "Run setup script manually:"
    echo "  bash scripts/setup_beocat_env.sh"
    exit 1
fi

echo "Environment ready!"
echo ""

# Create directories
mkdir -p data/tess
mkdir -p results
mkdir -p logs

# STEP 1: Download TESS data (just 3 targets for testing)
echo "=========================================="
echo "STEP 1: Downloading TESS Data"
echo "=========================================="
echo "Downloading 3 TESS light curves (test mode)..."
echo ""

cd scripts
python download_tess_data.py -n 3 -o ../data/tess

DOWNLOAD_EXIT=$?
echo ""
if [ $DOWNLOAD_EXIT -eq 0 ]; then
    echo "✅ Download completed successfully!"
else
    echo "⚠️  Download had errors (exit code: $DOWNLOAD_EXIT)"
    echo "Continuing to analysis if any files were downloaded..."
fi
echo ""

# Check if we got any data
NUM_FILES=$(ls -1 ../data/tess/*.fits 2>/dev/null | wc -l)
echo "Downloaded files: $NUM_FILES"

if [ $NUM_FILES -eq 0 ]; then
    echo "❌ No FITS files downloaded. Cannot proceed to analysis."
    echo "This may be due to network issues or MAST archive availability."
    exit 1
fi

# STEP 2: Analyze TESS data
echo "=========================================="
echo "STEP 2: Analyzing TESS Light Curves"
echo "=========================================="
echo "Running BLS periodogram analysis on $NUM_FILES light curves..."
echo ""

python analyze_tess_transits.py -d ../data/tess -o ../results

ANALYSIS_EXIT=$?
echo ""
if [ $ANALYSIS_EXIT -eq 0 ]; then
    echo "✅ Analysis completed successfully!"
else
    echo "❌ Analysis failed with exit code: $ANALYSIS_EXIT"
fi

cd ..

# Show results
echo ""
echo "=========================================="
echo "Results Summary"
echo "=========================================="

if [ -f results/analysis_summary.txt ]; then
    echo ""
    echo "=== Analysis Summary ==="
    cat results/analysis_summary.txt
    echo ""
fi

echo "Generated files:"
echo ""
echo "Data files:"
ls -lh data/tess/*.fits 2>/dev/null | awk '{printf "  %s  %s\n", $5, $9}'

echo ""
echo "Result plots:"
ls -lh results/*.png 2>/dev/null | awk '{printf "  %s  %s\n", $5, $9}'

echo ""
echo "Result summary:"
ls -lh results/*.txt 2>/dev/null | awk '{printf "  %s  %s\n", $5, $9}'

# Disk usage
echo ""
echo "Total disk usage:"
du -sh data results

echo ""
echo "=========================================="
echo "End time: $(date)"
echo "Total runtime: $SECONDS seconds"
echo "Exit code: $ANALYSIS_EXIT"
echo "=========================================="

if [ $ANALYSIS_EXIT -eq 0 ]; then
    echo "✅ TESS pipeline test completed successfully!"
    echo ""
    echo "Results location: $PROJECT_DIR/results/"
    echo ""
    echo "To view results:"
    echo "  ls -lh $PROJECT_DIR/results/"
    echo "  cat $PROJECT_DIR/results/analysis_summary.txt"
    echo ""
    echo "To clean up test data:"
    echo "  rm -rf $PROJECT_DIR/data/tess/*"
    echo "  rm -rf $PROJECT_DIR/results/*"
else
    echo "❌ Pipeline test completed with errors"
    echo ""
    echo "Check logs:"
    echo "  tail -100 /homes/tylerdoe/slurm_tess_test_${SLURM_JOB_ID}.out"
    echo "  tail -100 /homes/tylerdoe/slurm_tess_test_${SLURM_JOB_ID}.err"
fi

exit $ANALYSIS_EXIT
