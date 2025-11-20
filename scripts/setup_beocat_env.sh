#!/bin/bash
# Setup astronomy environment on Beocat
# Run this once to set up your Python environment with astronomy packages

set -e

echo "=== Beocat Astronomy Environment Setup ==="
echo ""

# Load required modules
echo "Loading Python module..."
module load Python/3.9

# Create virtual environment
ENV_DIR="$HOME/astro_env"
echo "Creating virtual environment at $ENV_DIR..."
python -m venv $ENV_DIR --system-site-packages

# Activate environment
source $ENV_DIR/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install astronomy packages
echo "Installing astronomy packages..."
pip install astropy
pip install lightkurve
pip install astroquery
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install h5py
pip install tqdm

# Optional: Machine learning packages
echo "Installing machine learning packages..."
pip install scikit-learn
pip install seaborn

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "To activate this environment in the future, run:"
echo "  module load Python/3.9"
echo "  source $ENV_DIR/bin/activate"
echo ""
echo "Add these lines to your Slurm job scripts!"
