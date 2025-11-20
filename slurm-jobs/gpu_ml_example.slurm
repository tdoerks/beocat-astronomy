#!/bin/bash
#SBATCH --job-name=astro_ml_gpu
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00
#SBATCH --mem=64G
#SBATCH --output=logs/gpu_ml_%j.out
#SBATCH --error=logs/gpu_ml_%j.err

# Template for GPU-accelerated machine learning on Beocat
# Use this for training neural networks on astronomy data

echo "Job started: $(date)"
echo "Running on node: $(hostname)"
echo "GPU device: $CUDA_VISIBLE_DEVICES"
echo ""

# Load modules
module load Python/3.9
module load TensorFlow  # or PyTorch, check with 'module avail'

# Activate astronomy environment
source $HOME/astro_env/bin/activate

# Create logs directory
mkdir -p logs

# Navigate to scripts directory
cd $SLURM_SUBMIT_DIR/scripts

# Example: Train a neural network for galaxy classification
# Replace with your actual ML script
# python train_galaxy_classifier.py

echo "TODO: Add your GPU machine learning script here"
echo ""
echo "Example use cases:"
echo "  - Galaxy image classification"
echo "  - Transit detection with CNNs"
echo "  - Gravitational wave signal processing"
echo "  - Stellar spectra analysis"

echo ""
echo "Job finished: $(date)"
