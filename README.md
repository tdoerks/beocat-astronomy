# Beocat Astronomy Project

HPC-powered astronomy data analysis on Kansas State University's Beocat cluster. This repository contains scripts and workflows for exoplanet detection, time-domain astronomy, and large-scale astronomical data processing.

## Project Overview

This project leverages Beocat's computational resources to:
- Analyze TESS exoplanet transit data
- Process large astronomical datasets
- Run machine learning models on GPU nodes
- Perform parallel data analysis at scale

## Repository Structure

```
beocat-astronomy/
├── scripts/           # Analysis and data processing scripts
│   ├── setup_beocat_env.sh      # Environment setup
│   ├── download_tess_data.py    # Download TESS light curves
│   └── analyze_tess_transits.py # Transit detection analysis
├── slurm-jobs/        # Slurm batch job templates
│   ├── download_data.slurm      # Data download job
│   ├── analyze_transits.slurm   # Transit analysis job
│   ├── gpu_ml_example.slurm     # GPU machine learning template
│   └── parallel_array.slurm     # Parallel array job template
├── notebooks/         # Jupyter notebooks for exploration
├── data/              # Data storage (gitignored)
├── results/           # Analysis results (gitignored)
└── docs/              # Documentation
```

## Quick Start Guide

### 1. Initial Setup on Beocat

First time only - set up your Python environment:

```bash
# Clone this repository
cd ~
git clone <your-repo-url> beocat-astronomy
cd beocat-astronomy

# Run setup script
bash scripts/setup_beocat_env.sh
```

This creates a virtual environment at `~/astro_env` with all required astronomy packages.

### 2. Download TESS Data

Download exoplanet transit data from TESS:

```bash
# Submit download job to Slurm
cd slurm-jobs
sbatch download_data.slurm

# Check job status
squeue -u $USER

# View output when complete
tail logs/download_*.out
```

### 3. Analyze Transits

Run transit detection analysis:

```bash
# Submit analysis job
sbatch analyze_transits.slurm

# Monitor progress
tail -f logs/analysis_*.out

# View results when complete
ls ../results/
```

## Available Scripts

### `scripts/download_tess_data.py`

Downloads TESS light curves for known exoplanet systems.

**Usage:**
```bash
python download_tess_data.py -n 10 -o ../data/tess
```

**Options:**
- `-n, --num-targets`: Number of targets to download (default: 10)
- `-o, --output-dir`: Output directory (default: ../data/tess)

### `scripts/analyze_tess_transits.py`

Performs BLS (Box Least Squares) periodogram analysis to detect transit signals.

**Usage:**
```bash
python analyze_tess_transits.py -d ../data/tess -o ../results
```

**Options:**
- `-d, --data-dir`: Directory containing TESS FITS files
- `-o, --output-dir`: Output directory for results

**Outputs:**
- Light curve plots (raw, flattened, periodogram)
- Phase-folded transit plots
- Summary text file with detected periods

## Slurm Job Templates

### Basic Job: `download_data.slurm`

Simple single-node job for downloading data.

**Submit:**
```bash
sbatch download_data.slurm
```

**Resources:**
- 1 node, 1 task
- 8GB memory
- 4 hour time limit

### Analysis Job: `analyze_transits.slurm`

Multi-core job for transit analysis.

**Submit:**
```bash
sbatch analyze_transits.slurm
```

**Resources:**
- 1 node, 4 CPUs
- 32GB memory
- 12 hour time limit

### GPU Job: `gpu_ml_example.slurm`

Template for GPU-accelerated machine learning.

**Submit:**
```bash
sbatch gpu_ml_example.slurm
```

**Resources:**
- 1 GPU node
- 64GB memory
- 48 hour time limit

**Use cases:**
- Galaxy classification with CNNs
- Transit detection with deep learning
- Gravitational wave analysis

### Array Job: `parallel_array.slurm`

Parallel processing across multiple nodes.

**Submit:**
```bash
sbatch parallel_array.slurm
```

**Configuration:**
- 10 parallel tasks (adjust `--array=1-10`)
- Each processes different data subset
- Ideal for large-scale surveys

## Beocat Resources

### Specifications

- **Nodes:** 343 compute nodes
- **Cores:** 8,368 CPU cores
- **GPUs:** 102 GPUs across 34 nodes
- **Storage:** 3.15 PB
- **Scheduler:** Slurm

### Useful Commands

```bash
# Check available modules
module avail

# Load Python
module load Python/3.9

# Activate environment
source ~/astro_env/bin/activate

# Submit job
sbatch myjob.slurm

# Check queue
squeue -u $USER

# Cancel job
scancel <job_id>

# View job details
scontrol show job <job_id>

# Check account usage
sreport cluster AccountUtilizationByUser
```

## Development Workflow

### Adding New Analysis Scripts

1. Create Python script in `scripts/`
2. Make executable: `chmod +x scripts/my_script.py`
3. Create corresponding Slurm job in `slurm-jobs/`
4. Test with small dataset first
5. Scale up to full analysis

### Best Practices

- **Start small:** Test with 1-10 targets before scaling to thousands
- **Monitor resources:** Check memory/CPU usage with `seff <job_id>`
- **Use array jobs:** For parallel processing of independent tasks
- **Save checkpoints:** For long-running jobs
- **Document results:** Keep notes in `results/` directory

## Data Sources

### TESS (Transiting Exoplanet Survey Satellite)

- **Mission:** NASA exoplanet hunter
- **Data:** 2-minute and 30-minute cadence light curves
- **Access:** Via `lightkurve` Python package
- **Archive:** MAST (Mikulski Archive for Space Telescopes)

### Future Data Sources

- **ZTF:** Zwicky Transient Facility (time-domain astronomy)
- **SDSS:** Sloan Digital Sky Survey (galaxy data)
- **LSST/Rubin:** Legacy Survey of Space and Time (coming soon)
- **LIGO:** Gravitational wave data

## Grant Opportunities

This work can support applications for:

- **Planetary Society Shoemaker NEO Grant** ($8k-12k)
- **NASA Citizen Science Seed Funding**
- **NSF Astronomy & Astrophysics Research Grants**
- **Mt. Cuba Astronomical Foundation** ($5k-250k)

### Grant Application Tips

Highlight in proposals:
- Access to Beocat HPC infrastructure
- Experience with large-scale data analysis
- Publications/discoveries from this work
- Computational expertise

## Contributing

To contribute to this project:

1. Create a new branch for your feature
2. Add scripts and documentation
3. Test on Beocat with small dataset
4. Submit pull request with description

## Resources & Documentation

- [Beocat Documentation](https://support.beocat.ksu.edu/BeocatDocs/)
- [Lightkurve Documentation](https://docs.lightkurve.org/)
- [TESS Data Products](https://heasarc.gsfc.nasa.gov/docs/tess/)
- [Slurm Documentation](https://slurm.schedmd.com/)

## Contact

Project maintained by: [Your Name]
Email: [Your Email]
Institution: Kansas State University

## License

MIT License - See LICENSE file for details

---

**Getting Started Checklist:**

- [ ] Clone repository to Beocat
- [ ] Run `setup_beocat_env.sh`
- [ ] Submit test download job
- [ ] Submit test analysis job
- [ ] Review results
- [ ] Scale up to larger datasets
- [ ] Document findings
- [ ] Consider grant applications

**Questions?** Check Beocat docs or contact beocat@cs.ksu.edu
