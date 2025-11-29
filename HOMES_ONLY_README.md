# Running TESS Pipeline from /homes (While /fastscratch is Down)

This guide shows how to run the TESS exoplanet pipeline entirely from `/homes` while `/fastscratch` is unavailable.

## Why This Works

Unlike genome assembly pipelines (COMPASS), the TESS astronomy pipeline:
- ✅ Uses **small data files** (TESS light curves = few MB each)
- ✅ Stores everything in **relative paths** (no hardcoded /fastscratch)
- ✅ Generates **lightweight results** (plots and text summaries)
- ✅ Fits comfortably within `/homes` quota

**Data size comparison:**
- COMPASS genome assembly: 10-50 GB per sample
- TESS light curve analysis: 2-5 MB per target
- **100x smaller!**

## Quick Start

### 1. Clone Repository to Beocat

SSH into Beocat and clone the repository:

```bash
cd /homes/tylerdoe
git clone https://github.com/tdoerks/beocat-astronomy.git
cd beocat-astronomy
```

### 2. Run Test Pipeline

Submit the test job that downloads and analyzes 3 TESS targets:

```bash
sbatch test_tess_from_homes.sh
```

**What it does:**
1. Sets up Python virtual environment (first time only)
2. Installs astronomy packages (lightkurve, astropy, etc.)
3. Downloads 3 TESS light curves (~5-10 MB total)
4. Analyzes for exoplanet transits using BLS periodogram
5. Generates plots and summary report

**Expected runtime:** 30-60 minutes (depending on MAST archive speed)

### 3. Monitor Progress

```bash
# Check job status
squeue -u $USER

# Watch output in real-time
tail -f /homes/tylerdoe/slurm_tess_test_*.out

# Check for errors
tail -f /homes/tylerdoe/slurm_tess_test_*.err
```

### 4. View Results

Once complete:

```bash
cd /homes/tylerdoe/beocat-astronomy/results

# View summary
cat analysis_summary.txt

# List generated plots
ls -lh *.png

# View plots (download to local machine via scp or view in JupyterHub)
```

## Disk Usage

Expected disk usage for test run (3 targets):
- **Data**: ~10 MB (FITS files)
- **Results**: ~5 MB (PNG plots + text summary)
- **Total**: ~15 MB

**You're currently at 982GB/1024GB (96%) in /homes**, so this is fine!

For a full production run (100+ targets):
- **Data**: ~200-500 MB
- **Results**: ~100 MB
- **Total**: ~300-600 MB (still very manageable)

## What Gets Created

```
beocat-astronomy/
├── astro_env/           # Python virtual environment (in $HOME)
├── data/
│   └── tess/            # Downloaded TESS FITS files
│       ├── TIC_25155310.fits
│       ├── TIC_219006104.fits
│       └── TIC_410214986.fits
├── results/
│   ├── analysis_summary.txt        # Text summary of detections
│   ├── TIC_25155310_analysis.png   # Light curve + periodogram
│   ├── TIC_25155310_folded.png     # Phase-folded transit
│   └── ...
└── logs/                # Empty (logs go to /homes/tylerdoe/)
```

## Environment Setup (Automatic)

The test script automatically creates a Python virtual environment at `~/astro_env` with:

- **Core astronomy:** astropy, lightkurve, astroquery
- **Data analysis:** numpy, scipy, pandas
- **Visualization:** matplotlib, seaborn
- **Machine learning:** scikit-learn
- **Utilities:** h5py, tqdm

This happens only on first run (~5-10 minutes). Subsequent runs reuse the environment.

## Manual Environment Setup (Optional)

If you want to set up the environment separately:

```bash
module load Python/3.9
bash scripts/setup_beocat_env.sh
```

Then modify job scripts to activate it:

```bash
source ~/astro_env/bin/activate
```

## Scaling Up

Once test works, you can scale up:

### Download More Targets

```bash
# Modify test script or submit custom job
sbatch --export=NUM_TARGETS=20 download_data.slurm
```

### Run Full Analysis

```bash
# Analyze all downloaded light curves
sbatch analyze_transits.slurm
```

### Array Jobs (Parallel Processing)

```bash
# Process 50 targets in parallel (10 jobs × 5 targets each)
sbatch parallel_array.slurm
```

## Troubleshooting

### "Cannot import lightkurve"

Environment not set up. Run:
```bash
bash scripts/setup_beocat_env.sh
```

### "No data found for TIC XXXXX"

Some targets may not have TESS data available. This is normal - the script skips them and continues.

### "Network timeout" or "MAST unavailable"

The MAST archive may be temporarily down. Wait and retry later:
```bash
sbatch test_tess_from_homes.sh
```

### Jobs pending in queue

Check queue status:
```bash
squeue -u $USER
showq
```

If Beocat is busy, jobs may wait. Use `seff <job_id>` after completion to check resource usage.

## Cleaning Up Test Data

After verifying everything works:

```bash
cd /homes/tylerdoe/beocat-astronomy

# Remove test data
rm -rf data/tess/*
rm -rf results/*

# Keep environment for future runs
# (DO NOT remove ~/astro_env unless you want to reinstall packages)
```

## Production Workflow

For regular use:

1. **Download session** (once per week/month):
   ```bash
   sbatch download_data.slurm  # Downloads new TESS targets
   ```

2. **Analysis session**:
   ```bash
   sbatch analyze_transits.slurm  # Analyzes all downloaded data
   ```

3. **Review results**:
   - Download plots to local machine
   - Look for interesting transit signals
   - Note candidates for follow-up

4. **Archive**:
   - Move results to `/bulk` for long-term storage
   - Keep active working data in `/homes`

## Why /homes Works for This

| Factor | COMPASS Pipeline | TESS Pipeline |
|--------|------------------|---------------|
| Input data size | 1-10 GB/sample | 2-5 MB/target |
| Output data size | 500 MB - 5 GB/sample | 1-2 MB/target (plots) |
| Temp files | Massive (assembly graphs) | Minimal |
| I/O intensity | Very high | Low |
| **Feasible on /homes?** | ❌ No | ✅ **Yes!** |

## Next Steps

After test run succeeds:

1. ✅ **Works!** - Scale up to 10-20 targets
2. ✅ **Review plots** - Look for interesting transits
3. ✅ **Document findings** - Add notes to results directory
4. ✅ **Consider grants** - Use for Planetary Society or NASA proposals
5. ✅ **Publish/share** - Citizen science contributions to TESS community

## Contact

Questions about running on Beocat?
- Beocat support: beocat@cs.ksu.edu
- Tyler Doerks: tdoerks@vet.k-state.edu

## References

- [TESS Mission](https://tess.mit.edu/)
- [Lightkurve Documentation](https://docs.lightkurve.org/)
- [Beocat User Guide](https://support.beocat.ksu.edu/BeocatDocs/)
- [BLS Periodogram Method](https://docs.astropy.org/en/stable/timeseries/bls.html)
