# Beocat Astronomy Project

HPC-powered astronomy data analysis on Kansas State University's Beocat cluster. This repository contains scripts and workflows for exoplanet detection, time-domain astronomy, and large-scale astronomical data processing.

## Project Overview

This project leverages Beocat's computational resources to analyze TESS exoplanet transit data using a comprehensive 3-phase pipeline:

**Phase 1:** Validate pipeline on 33 confirmed exoplanets
**Phase 2:** Analyze 196 TOI candidates (unconfirmed exoplanets)
**Phase 2B:** Scale to ALL ~7,000 TOI candidates (24-hour run) ⭐ **NEW!**
**Phase 3:** Search 1,000 random stars for missed transits (discovery mode)

### Completed Milestones:
✅ Phase 1: 9/9 test exoplanets successfully detected
✅ Phase 2: 196/196 TOI candidates analyzed (13 minutes)
✅ Strong signals found: TOI-123 (power: 13,536!)
🚀 **Phase 2B: Ready to analyze entire TOI catalog (~7,000 candidates!)**

## Repository Structure

```
beocat-astronomy/
├── scripts/           # Analysis and data processing scripts
│   ├── setup_beocat_env.sh          # Environment setup
│   ├── download_tess_data.py        # Phase 1: Download confirmed exoplanets
│   ├── download_tess_toi.py         # Phase 2/2B: Download TOI candidates
│   ├── download_tess_random.py      # Phase 3: Random star search
│   └── analyze_tess_transits.py     # BLS transit detection analysis
├── slurm-jobs/        # Slurm batch job templates
│   ├── download_data.slurm              # Phase 1 download
│   ├── download_phase2_toi.slurm        # Phase 2 download (200 TOIs)
│   ├── download_phase2b_all_tois.slurm  # Phase 2B download (7,000 TOIs) ⭐
│   ├── download_phase3_random.slurm     # Phase 3 download
│   ├── analyze_phase1_confirmed.slurm   # Phase 1 analysis
│   ├── analyze_phase2_toi.slurm         # Phase 2 analysis
│   ├── analyze_phase2b_all_tois.slurm   # Phase 2B analysis (full catalog) ⭐
│   └── analyze_phase3_random.slurm      # Phase 3 analysis
├── data/              # Data storage (gitignored)
│   ├── tess/              # Phase 1: Confirmed exoplanet light curves
│   ├── tess_toi/          # Phase 2: 196 TOI candidate light curves
│   ├── tess_toi_full/     # Phase 2B: ~7,000 TOI light curves ⭐
│   └── tess_random/       # Phase 3: Random star light curves
├── results/           # Analysis results (gitignored)
│   ├── phase1_confirmed/  # Phase 1 results
│   ├── phase2_toi/        # Phase 2 results (196 TOIs, 392 plots)
│   ├── phase2b_toi_full/  # Phase 2B results (~14,000 plots!) ⭐
│   └── phase3_random/     # Phase 3 results
├── GIT_WORKFLOW.md    # Git branching strategy (main vs stable)
├── SESSION_STATUS.md  # Current session status and next steps
├── PHASE2B_LAUNCH.md  # Complete guide for Phase 2B launch ⭐
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

### 2. Run Phase 2B: Analyze ALL ~7,000 TOI Candidates! ⭐

The fastest way to contribute to exoplanet science - analyze the entire TESS TOI catalog:

```bash
cd slurm-jobs

# Step 1: Download all ~7,000 TOI candidates (12 hours)
sbatch download_phase2b_all_tois.slurm

# Check status
squeue -u $USER

# Step 2: When download completes, analyze all TOIs (8 hours)
sbatch analyze_phase2b_all_tois.slurm

# View results summary
cat ../results/phase2b_toi_full/analysis_summary.txt
```

**See `PHASE2B_LAUNCH.md` for complete details!**

### 3. Alternative: Run Individual Phases

**Phase 1 - Validate Pipeline (33 confirmed exoplanets):**
```bash
cd slurm-jobs
sbatch download_data.slurm
sbatch analyze_phase1_confirmed.slurm
```

**Phase 2 - Test TOI Analysis (196 candidates):**
```bash
sbatch download_phase2_toi.slurm
sbatch analyze_phase2_toi.slurm
```

**Phase 3 - Random Star Search (1,000 stars, discovery mode):**
```bash
sbatch download_phase3_random.slurm
sbatch analyze_phase3_random.slurm
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
