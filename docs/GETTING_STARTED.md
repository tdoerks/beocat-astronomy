# Getting Started with Beocat Astronomy

Complete beginner's guide to running astronomy analyses on Beocat HPC.

## Prerequisites

1. **Beocat Account:** Contact beocat@cs.ksu.edu to request access
2. **SSH Access:** Ability to connect to Beocat via SSH
3. **Basic Linux:** Familiarity with command line

## Step-by-Step Setup

### 1. Connect to Beocat

```bash
# From your local machine
ssh your-eid@beocat.ksu.edu

# Enter your password when prompted
```

### 2. Clone This Repository

```bash
# Navigate to your home directory
cd ~

# Clone the repository (replace with actual URL)
git clone https://github.com/yourusername/beocat-astronomy.git

# Enter the directory
cd beocat-astronomy
```

### 3. Set Up Python Environment

```bash
# Make the setup script executable
chmod +x scripts/setup_beocat_env.sh

# Run the setup (takes ~5-10 minutes)
bash scripts/setup_beocat_env.sh
```

This will:
- Load Python 3.9 module
- Create virtual environment at `~/astro_env`
- Install astronomy packages (astropy, lightkurve, etc.)
- Install analysis tools (numpy, scipy, matplotlib)

### 4. Test Your Environment

```bash
# Load Python module
module load Python/3.9

# Activate environment
source ~/astro_env/bin/activate

# Test imports
python -c "import lightkurve; print('Success!')"
```

If you see "Success!", you're ready to go!

## Your First Analysis

### Step 1: Download Sample Data

Create a logs directory first:

```bash
cd ~/beocat-astronomy/slurm-jobs
mkdir -p logs
```

Submit the download job:

```bash
sbatch download_data.slurm
```

Check the job status:

```bash
# See your jobs in the queue
squeue -u $USER

# When job completes, check the output
cat logs/download_*.out
```

### Step 2: Run Transit Analysis

Once data is downloaded, analyze it:

```bash
sbatch analyze_transits.slurm
```

Monitor the job:

```bash
# Watch the output file in real-time
tail -f logs/analysis_*.out

# Press Ctrl+C to stop watching
```

### Step 3: View Results

```bash
# Check what was created
ls -lh ../results/

# View the summary
cat ../results/analysis_summary.txt
```

Results include:
- Light curve plots for each target
- BLS periodogram showing detected periods
- Phase-folded plots at best period
- Summary file with all detections

## Understanding Slurm Jobs

### Basic Slurm Commands

```bash
# Submit a job
sbatch myjob.slurm

# Check your jobs
squeue -u $USER

# Cancel a job
scancel <job_id>

# View job details
scontrol show job <job_id>

# Check job efficiency after completion
seff <job_id>
```

### Slurm Job Anatomy

Example from `download_data.slurm`:

```bash
#!/bin/bash
#SBATCH --job-name=tess_download    # Name that appears in queue
#SBATCH --nodes=1                   # Number of nodes
#SBATCH --ntasks=1                  # Number of tasks
#SBATCH --time=04:00:00            # Max runtime (4 hours)
#SBATCH --mem=8G                    # Memory per node
#SBATCH --output=logs/download_%j.out  # Output file (%j = job ID)

# Your commands here
module load Python/3.9
source ~/astro_env/bin/activate
python my_script.py
```

### Common Issues

**Problem:** Job fails immediately
```bash
# Check the error log
cat logs/download_*.err

# Common causes:
# - Missing logs/ directory (create it: mkdir -p logs)
# - Wrong path to environment
# - Module not loaded
```

**Problem:** Job pending forever
```bash
# Check why it's pending
squeue -u $USER --start

# May need to:
# - Reduce requested resources
# - Check partition availability
```

**Problem:** Out of memory
```bash
# Check memory usage with seff
seff <job_id>

# Increase in Slurm script:
#SBATCH --mem=32G  # or higher
```

## Customizing Your Analysis

### Analyze Different Targets

Edit `scripts/download_tess_data.py` to add your own TIC IDs:

```python
tic_ids = [
    'TIC 25155310',   # Your targets here
    'TIC 219006104',
    # Add more...
]
```

### Adjust Processing Parameters

Edit `scripts/analyze_tess_transits.py`:

```python
# Change periodogram range
periodogram = flat_lc.to_periodogram(
    method='bls',
    period=np.arange(0.5, 30, 0.001)  # Search 0.5-30 days
)

# Adjust outlier removal
lc = lc.remove_outliers(sigma=3)  # More/less aggressive
```

### Request More Resources

Edit Slurm scripts:

```bash
#SBATCH --nodes=1        # More nodes for parallel tasks
#SBATCH --ntasks=16      # More CPUs
#SBATCH --mem=128G       # More memory
#SBATCH --time=48:00:00  # More time
```

## Next Steps

Once comfortable with basics:

1. **Scale Up:** Download 100+ targets
2. **GPU Analysis:** Try machine learning with `gpu_ml_example.slurm`
3. **Array Jobs:** Process thousands of targets in parallel
4. **Custom Analysis:** Write your own detection algorithms
5. **Publications:** Document discoveries for papers
6. **Grant Applications:** Use results to apply for funding

## Tips for Efficient HPC Use

### Development Workflow

1. **Test locally first:** Write/debug on small data on login node
2. **Small Slurm test:** Submit with 1-2 targets, short time limit
3. **Scale up:** Once working, increase to full dataset
4. **Monitor:** Check resource usage with `seff` to optimize

### Resource Requests

- **Be conservative:** Don't request 100GB if you need 10GB
- **Use `seff`:** After jobs run, check actual usage
- **Array jobs:** Better than single huge job
- **Checkpointing:** Save progress for long jobs

### Data Management

```bash
# Check your disk usage
du -sh ~/beocat-astronomy

# Clean up old results
rm -rf results/old_analysis/

# Compress large files
gzip data/tess/*.fits
```

## Getting Help

### Beocat Support

- **Email:** beocat@cs.ksu.edu
- **Documentation:** https://support.beocat.ksu.edu/BeocatDocs/
- **Office Hours:** Check Beocat website

### Astronomy Questions

- **Lightkurve Tutorials:** https://docs.lightkurve.org/
- **TESS Data Products:** https://heasarc.gsfc.nasa.gov/docs/tess/
- **Astropy Documentation:** https://docs.astropy.org/

### Debugging Checklist

- [ ] Is my virtual environment activated?
- [ ] Are modules loaded? (`module list`)
- [ ] Does logs/ directory exist?
- [ ] Are file paths correct in scripts?
- [ ] Do I have enough disk space? (`quota`)
- [ ] Are permissions correct? (`ls -l`)

## Reference

### Module Commands
```bash
module avail              # List all available modules
module list               # Show loaded modules
module load Python/3.9    # Load a module
module unload Python      # Unload a module
module purge              # Unload all modules
```

### Useful Aliases

Add to `~/.bashrc`:

```bash
alias beojobs='squeue -u $USER'
alias beoload='module load Python/3.9 && source ~/astro_env/bin/activate'
alias beologs='ls -lht ~/beocat-astronomy/slurm-jobs/logs/ | head'
```

Then: `source ~/.bashrc`

---

**You're ready to start!** Begin with the Quick Start guide in the main README.
