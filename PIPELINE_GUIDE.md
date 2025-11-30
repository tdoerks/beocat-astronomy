# TESS Exoplanet Transit Detection Pipeline

**Complete guide to reproduce the full analysis pipeline**

---

## Overview

This pipeline downloads TESS light curves and analyzes them for exoplanet transits using BLS (Box Least Squares) periodogram analysis. It supports three modes:

1. **Phase 1**: Validate pipeline on confirmed exoplanets
2. **Phase 2**: Analyze TOI (TESS Objects of Interest) candidates
3. **Phase 3**: Random star search for new discoveries

---

## Quick Start (Full Pipeline)

### 1. Initial Setup

```bash
# Clone repository
cd /homes/yourusername
git clone https://github.com/tdoerks/beocat-astronomy.git
cd beocat-astronomy

# Set up Python environment
bash scripts/setup_beocat_env.sh

# Creates: ~/astro_env with lightkurve, numpy, matplotlib, etc.
```

### 2. Launch Downloads (All Phases in Parallel)

```bash
cd slurm-jobs

# Phase 1: 33 confirmed exoplanets (validation)
sbatch download_data.slurm

# Phase 2B: ALL 7,000 TOI candidates (comprehensive catalog)
sbatch download_phase2b_all_tois.slurm

# Phase 3 MEGA: 10,000 random stars (discovery mode)
sbatch download_phase3_mega_10k.slurm

# Check status
squeue -u $USER
```

### 3. Launch Analysis (After Downloads Complete)

```bash
# When Phase 1 download finishes (~10 minutes):
sbatch analyze_phase1_confirmed.slurm

# When Phase 2B download finishes (~14 hours):
sbatch analyze_phase2b_all_tois.slurm

# When Phase 3 MEGA download finishes (~24 hours):
# Create custom analysis job for mega dataset (see below)
```

---

## Detailed Pipeline Steps

### Phase 1: Pipeline Validation (Confirmed Exoplanets)

**Purpose:** Verify the pipeline works on known exoplanets with confirmed periods

**Steps:**

```bash
cd /homes/yourusername/beocat-astronomy/slurm-jobs

# 1. Download confirmed exoplanet light curves
sbatch download_data.slurm

# 2. Check download results (~10 minutes)
squeue -u $USER
cat logs/download_*.out
ls -1 ../data/tess/*.fits | wc -l  # Should show ~33 files

# 3. Analyze the light curves
sbatch analyze_phase1_confirmed.slurm

# 4. Review results (~1 hour)
cat ../results/phase1_confirmed/analysis_summary.txt
ls ../results/phase1_confirmed/*.png | wc -l  # Should show ~66 plots
```

**Expected Results:**
- 33 confirmed exoplanets downloaded
- Detected periods should match known values
- Strong transit signals (power > 1,000)

---

### Phase 2: TOI Candidate Validation

#### Option A: Small Test (196 TOIs)

```bash
# Download 196 TOI candidates (TOI-100 to TOI-299)
sbatch download_phase2_toi.slurm

# Analyze after download completes
sbatch analyze_phase2_toi.slurm

# Review
cat ../results/phase2_toi/analysis_summary.txt
```

#### Option B: Full Catalog (7,000 TOIs) ⭐ **RECOMMENDED**

```bash
# Download ALL known TOI candidates
sbatch download_phase2b_all_tois.slurm

# Monitor progress (will take ~14 hours)
tail -f logs/phase2b_all_tois_download_*.err

# Check progress periodically
ls -1 ../data/tess_toi_full/*.fits | wc -l

# When complete, analyze all TOIs
sbatch analyze_phase2b_all_tois.slurm

# Review top signals
grep "Transit power:" ../results/phase2b_toi_full/analysis_summary.txt | sort -t: -k2 -n | tail -50
```

**Expected Results:**
- ~6,000-7,000 TOI light curves downloaded (not all TOI numbers exist)
- ~14,000 plots generated
- Strong signals = likely confirmed exoplanets!
- Weak signals = false positives or need follow-up

---

### Phase 3: Random Star Discovery Mode

#### Option A: Small Sample (500-1,000 stars)

```bash
# Download ~500 random stars
sbatch download_phase3_random.slurm

# Analyze
sbatch analyze_phase3_random.slurm

# Review discoveries
cat ../results/phase3_random/analysis_summary.txt
```

#### Option B: Large Sample (10,000 stars) ⭐ **UNPRECEDENTED!**

```bash
# Download 10,000 random TESS stars
sbatch download_phase3_mega_10k.slurm

# Monitor (will take ~20-24 hours)
tail -f logs/phase3_mega_10k_*.out

# Check progress
ls -1 ../data/tess_random_mega_10k/*.fits | wc -l

# When complete, analyze (create custom job - see below)
```

**Expected Results:**
- ~10,000 random TESS light curves
- Mix of SPOC (2-min) and FFI (30-min) cadence data
- ~10% hit rate when searching random TIC IDs
- Any strong transit signals = potential NEW exoplanet discoveries!

---

## Custom Analysis Jobs

### Analyzing Custom Datasets

To analyze any directory of TESS FITS files:

```bash
cd /homes/yourusername/beocat-astronomy/scripts

# Direct command line
python analyze_tess_transits.py -d /path/to/fits/files -o /path/to/results

# Or create custom SLURM job (copy and modify existing analyze_*.slurm)
```

### Creating Analysis Job for Phase 3 MEGA

```bash
# Copy existing analysis job
cd slurm-jobs
cp analyze_phase3_random.slurm analyze_phase3_mega_10k.slurm

# Edit to update paths
nano analyze_phase3_mega_10k.slurm

# Change these lines:
# - Job name: tess_analyze_phase3_mega_10k
# - Input: -d ../data/tess_random_mega_10k
# - Output: -o ../results/phase3_mega_10k
# - Time: --time=12:00:00 (may need more for 10k stars)

# Submit
sbatch analyze_phase3_mega_10k.slurm
```

---

## Download Script Parameters

### `download_tess_random.py` - Random Star Downloads

**Parameters:**
```bash
python download_tess_random.py -n <num_targets> -o <output_dir> -s <seed>

-n, --num-targets  : Number of stars to download (default: 1000)
-o, --output-dir   : Output directory (default: ../data/tess_random)
-s, --seed         : Random seed for reproducibility (default: 42)
```

**Examples:**
```bash
# Download 500 stars with seed=2025
python download_tess_random.py -n 500 -o ../data/batch2 -s 2025

# Download 10,000 stars with seed=9999
python download_tess_random.py -n 10000 -o ../data/mega -s 9999
```

**Key Features:**
- Searches random TIC IDs from 1M to 500M
- Accepts SPOC (2-min) and FFI (30-min) data
- ~10% hit rate (searches 10x target to find enough stars)
- Different seeds = different random samples (no overlap)

### `download_tess_toi.py` - TOI Candidate Downloads

**Parameters:**
```bash
python download_tess_toi.py -n <num_targets> -o <output_dir>

-n, --num-targets : Number of TOI candidates (default: 200)
-o, --output-dir  : Output directory (default: ../data/tess_toi)
```

**Examples:**
```bash
# Download 200 TOIs (TOI-1 to TOI-200)
python download_tess_toi.py -n 200 -o ../data/tess_toi

# Download all 7,000 TOIs
python download_tess_toi.py -n 7000 -o ../data/tess_toi_full
```

### `analyze_tess_transits.py` - Transit Analysis

**Parameters:**
```bash
python analyze_tess_transits.py -d <data_dir> -o <output_dir>

-d, --data-dir   : Directory containing TESS FITS files
-o, --output-dir : Output directory for results
```

**What it does:**
1. Reads all FITS files in data directory
2. Removes outliers and flattens light curve
3. Runs BLS periodogram (searches periods 0.5-20 days)
4. Generates analysis plot (raw, flattened, periodogram)
5. Generates phase-folded transit plot
6. Saves summary to `analysis_summary.txt`

**Output files:**
- `TIC_*.fits` → `TIC_*_analysis.png` + `TIC_*_folded.png`
- `analysis_summary.txt` - All detected periods and powers

---

## Understanding Results

### Transit Power Interpretation

**Transit Power** = Signal strength from BLS periodogram

| Power Range | Interpretation |
|-------------|----------------|
| < 100 | Very weak, likely noise |
| 100 - 500 | Weak signal, questionable |
| 500 - 1,000 | Moderate signal, worth inspecting |
| 1,000 - 10,000 | Strong signal, likely real transit |
| 10,000 - 100,000 | Very strong, confirmed exoplanet or eclipsing binary |
| > 100,000 | Extremely strong, likely eclipsing binary or artifact |

### Period Interpretation

**Typical Exoplanet Periods:**
- 0.5 - 2 days: Ultra-short period (hot Jupiters, hot Neptunes)
- 2 - 10 days: Short period (hot planets)
- 10 - 20 days: Moderate period (warm planets)
- > 20 days: Not searched by this pipeline (too long)

**Red Flags:**
- Period < 0.5 days: Likely stellar pulsation or artifact
- Period exactly at integer days: Possible instrumental effect
- Power > 1,000,000: Likely eclipsing binary, not exoplanet

### Finding Discoveries in Random Stars

```bash
# Sort by transit power to find strongest signals
grep "Transit power:" ../results/phase3_*/analysis_summary.txt | \
  sort -t: -k3 -n | tail -50

# Look for signals with:
# - Power > 1,000 (strong detection)
# - Period 0.5-20 days (planetary range)
# - Reasonable transit depth (check plots)

# Download plots for visual inspection
scp user@beocat.ksu.edu:/path/to/TIC_*_analysis.png ./
```

**Manual Inspection:**
1. Check phase-folded plot shows clear transit shape
2. Verify transits are periodic (not single event)
3. Compare to known exoplanet databases (NASA Exoplanet Archive)
4. If truly new → Potential discovery! 🎉

---

## Storage Requirements

### Typical Storage per Phase

| Phase | Data | Plots | Total |
|-------|------|-------|-------|
| Phase 1 (33 confirmed) | 30 MB | 30 MB | 60 MB |
| Phase 2 (196 TOIs) | 168 MB | 109 MB | 277 MB |
| Phase 2B (7,000 TOIs) | 6 GB | 7 GB | 13 GB |
| Phase 3 (529 random) | 500 MB | 500 MB | 1 GB |
| Phase 3 MEGA (10,000 random) | 10 GB | 10 GB | 20 GB |

**Full pipeline storage:** ~35-50 GB

**Recommended:** 100 GB minimum, 1 TB ideal

---

## Performance Benchmarks

**Download Rates:**
- Confirmed exoplanets: ~5 stars/minute
- TOI candidates: ~3-5 TOIs/minute (variable, many don't exist)
- Random stars: ~2-3 stars/minute (10% hit rate)

**Analysis Rates:**
- ~15 stars/minute (on 4-CPU node with 32GB RAM)
- 1,000 stars: ~1 hour
- 10,000 stars: ~10 hours

**Typical Job Times:**
- Phase 1 download: 10 minutes
- Phase 1 analysis: 1 hour
- Phase 2B download: 12-14 hours
- Phase 2B analysis: 8 hours
- Phase 3 MEGA download: 20-24 hours
- Phase 3 MEGA analysis: 10-12 hours

---

## Troubleshooting

### Downloads Failing

**Problem:** Many "No data found" messages

**Solution:** Normal! Not all TOI numbers or random TIC IDs have TESS data. The scripts handle this gracefully.

**Problem:** All downloads failing

**Solution:**
- Check MAST archive status: https://mast.stsci.edu/
- Check lightkurve: `python -c "import lightkurve; print(lightkurve.__version__)"`
- Clear cache: `rm -rf ~/.lightkurve/cache/`

### Analysis Failing

**Problem:** "lightkurve not found"

**Solution:** Check environment activation in SLURM script uses absolute path:
```bash
ASTRO_ENV="/homes/yourusername/astro_env"
source $ASTRO_ENV/bin/activate
```

**Problem:** Unit compatibility errors

**Solution:** Already fixed in `analyze_tess_transits.py` with manual normalization

### Low Hit Rate in Random Search

**Problem:** Only getting 0.04% hit rate

**Solution:** Ensure `download_tess_random.py` does NOT have `author='SPOC'` filter:
```python
# CORRECT (accepts both SPOC and FFI):
search_result = lk.search_lightcurve(f'TIC {tic_id}', mission='TESS')

# WRONG (only SPOC, very low hit rate):
search_result = lk.search_lightcurve(f'TIC {tic_id}', mission='TESS', author='SPOC')
```

---

## Reproducibility Notes

### Random Seed Usage

For reproducible random star samples:
- **Seed 42**: Original Phase 3 v2 (529 stars)
- **Seed 2025**: Phase 3c batch 2 (500 stars)
- **Seed 9999**: Phase 3 MEGA (10,000 stars)

Different seeds = completely different random samples (no overlap)

### Git Workflow

**Branches:**
- `main`: Development and testing
- `stable`: Proven, production-ready code

**Tags:**
- `v1.0-initial-working`: First validated version (9 exoplanets)
- Future tags for major milestones

See `GIT_WORKFLOW.md` for details.

---

## Scientific Applications

### Publication-Ready Results

When you have completed analyses:

1. **Phase 1:** Shows pipeline reliability (validated on known planets)
2. **Phase 2B:** Comprehensive TOI catalog analysis (help confirm candidates)
3. **Phase 3:** Novel random star search (potential discoveries!)

### Grant Applications

This pipeline demonstrates:
- HPC expertise (parallel SLURM jobs)
- Large-scale data analysis (18,000+ light curves)
- Scientific computing (BLS algorithm, time-series analysis)
- Discovery potential (random star search)

Applicable for:
- Planetary Society grants
- NASA ROSES proposals
- NSF Astronomy grants

### Sharing Results

```bash
# Create tarball of results for collaborators
cd /homes/yourusername/beocat-astronomy
tar -czf tess_results.tar.gz results/

# Or sync to /bulk for long-term storage
rsync -av results/ /bulk/yourusername/tess_archive/
```

---

## Scaling Beyond 10,000 Stars

Want to go even bigger? The pipeline can handle it!

**100,000 random stars:**
- Download: ~200 hours (~8 days)
- Storage: ~100 GB data + 100 GB plots = 200 GB
- Analysis: ~100 hours (~4 days)
- Scientific impact: Unprecedented random TESS survey!

**Optimization strategies:**
- Run multiple download jobs in parallel with different seeds
- Split analysis into batches (e.g., 10 jobs × 10,000 stars each)
- Use array jobs for parallelization

---

## Credits & References

**Pipeline developed by:** Tyler Doe (Kansas State University)

**Key software:**
- Lightkurve: https://docs.lightkurve.org/
- TESS Mission: https://tess.mit.edu/
- BLS Algorithm: Kovács et al. (2002)

**Data sources:**
- MAST Archive: https://mast.stsci.edu/
- TOI Catalog: https://exofop.ipac.caltech.edu/tess/
- TIC (TESS Input Catalog): Stassun et al. (2018)

---

## Quick Reference Card

```bash
# Setup (once)
git clone <repo>
bash scripts/setup_beocat_env.sh

# Launch downloads (parallel)
cd slurm-jobs
sbatch download_data.slurm                  # Phase 1
sbatch download_phase2b_all_tois.slurm      # Phase 2B
sbatch download_phase3_mega_10k.slurm       # Phase 3 MEGA

# Check status
squeue -u $USER
ls -1 ../data/*/*.fits | wc -l

# Launch analysis (after downloads)
sbatch analyze_phase1_confirmed.slurm       # Phase 1
sbatch analyze_phase2b_all_tois.slurm       # Phase 2B
sbatch analyze_phase3_mega_10k.slurm        # Phase 3 (custom)

# Review results
cat ../results/*/analysis_summary.txt
grep "Transit power:" ../results/*/analysis_summary.txt | sort -t: -k3 -n | tail -50
```

---

**This pipeline is ready for production use and full scientific reproducibility!** 🚀
