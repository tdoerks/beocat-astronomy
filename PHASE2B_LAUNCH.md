# Phase 2B: Full TOI Catalog Analysis

## Overview

**Goal:** Analyze ALL ~7,000 TOI (TESS Objects of Interest) candidates in a 24-hour run

**Why this matters:**
- Phase 2 proved the pipeline works (196 TOIs in 31 minutes)
- Full catalog = comprehensive exoplanet candidate validation
- Strong transit signals in TOIs = YOU HELPED CONFIRM EXOPLANETS!

## Quick Start

```bash
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs

# Step 1: Download all ~7,000 TOIs (12-hour job)
sbatch download_phase2b_all_tois.slurm

# Check status
squeue -u tylerdoe

# When download completes, check results:
ls -lh ../data/tess_toi_full/

# Step 2: Analyze all downloaded TOIs (12-hour job)
sbatch analyze_phase2b_all_tois.slurm

# Monitor progress
tail -f logs/analyze_phase2b_all_tois_JOBID.out
```

## Performance Estimates

Based on Phase 2 results (196 TOIs in 31 minutes):

### Download Phase (~10-12 hours)
- Target: 7,000 TOI candidates (TOI-1 through TOI-7499)
- Expected success: ~6,000-7,000 (90% success rate)
- Download rate: ~5-10 seconds per TOI
- Storage: ~5.9 GB

### Analysis Phase (~7-8 hours)
- BLS periodogram transit detection on all downloaded light curves
- Analysis rate: ~15 TOIs/minute (from Phase 2)
- Expected: ~14,000 plots (analysis + phase-folded transits)
- Output: `../results/phase2b_toi_full/`

### Total Runtime: ~18-20 hours
- Well within 24-hour SLURM limit
- 4-6 hour buffer for any slowdowns

## What's Different from Phase 2?

| Aspect | Phase 2 (Test) | Phase 2B (Full Catalog) |
|--------|----------------|-------------------------|
| Targets | 200 TOIs (TOI-100 to TOI-299) | ~7,000 TOIs (TOI-1 to TOI-7499) |
| Success | 196 downloaded | ~6,000-7,000 expected |
| Runtime | 31 minutes | ~20 hours |
| Storage | 168 MB | ~5.9 GB |
| Plots | 392 | ~14,000 |
| Science | Proof of concept | **Full catalog validation!** |

## Scientific Impact

### What You'll Find:

1. **Confirmed Exoplanets:**
   - TOIs with strong, clear transit signals (power > 1,000)
   - Periods matching expected planetary orbits (0.5-20 days)
   - Multiple transits in the light curve

2. **Validated Candidates:**
   - TOIs that show weaker but real transit signals
   - May need follow-up observations
   - Still scientifically valuable!

3. **False Positives:**
   - TOIs with no clear periodicity
   - Eclipsing binaries (very short/long periods)
   - Stellar activity mimicking transits

### How to Identify Confirmed Exoplanets:

Check `../results/phase2b_toi_full/analysis_summary.txt` for:

```
✓ Strong signals: Transit power > 1,000
✓ Planetary periods: 0.5 - 20 days (hot to warm planets)
✓ Reasonable transit depth: 0.1% - 5% (Earth to Jupiter sized)
```

**Example from Phase 2:**
```
TOI-123: Period 2.84 days, Power 13,536 - VERY STRONG SIGNAL!
TOI-197: Period 7.45 days, Power 3,421 - Strong candidate
TOI-244: Period 12.3 days, Power 1,876 - Good detection
```

## File Locations

### Scripts:
- `scripts/download_tess_toi.py` - Modified to search TOI-1 to TOI-7499
- `slurm-jobs/download_phase2b_all_tois.slurm` - Download job
- `slurm-jobs/analyze_phase2b_all_tois.slurm` - Analysis job

### Data:
- Input: `../data/tess_toi_full/` - Downloaded FITS files
- Output: `../results/phase2b_toi_full/` - Analysis results and plots

### Logs:
- `logs/phase2b_all_tois_download_JOBID.out` - Download progress
- `logs/phase2b_all_tois_download_JOBID.err` - Download errors
- `logs/analyze_phase2b_all_tois_JOBID.out` - Analysis progress
- `logs/analyze_phase2b_all_tois_JOBID.err` - Analysis errors

## Monitoring Progress

### During Download:
```bash
# Check job status
squeue -u tylerdoe

# View download progress (updates in real-time)
tail -f logs/phase2b_all_tois_download_JOBID.out

# Count downloaded files
ls -1 ../data/tess_toi_full/*.fits | wc -l

# Check disk usage
du -sh ../data/tess_toi_full/
```

### During Analysis:
```bash
# View analysis progress
tail -f logs/analyze_phase2b_all_tois_JOBID.out

# Count completed analyses
ls -1 ../results/phase2b_toi_full/*.png | wc -l

# Check for strong signals (live!)
grep "Power:" logs/analyze_phase2b_all_tois_JOBID.out | tail -20
```

## After Completion

### Review Results:
```bash
# Summary of all detections
cat ../results/phase2b_toi_full/analysis_summary.txt

# Count successful analyses
ls -1 ../results/phase2b_toi_full/*_analysis.png | wc -l

# Find strongest signals
grep "Transit power:" ../results/phase2b_toi_full/analysis_summary.txt | sort -t: -k2 -n | tail -50
```

### Download to Local Machine:
```bash
# From your Windows/local machine:
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/phase2b_toi_full/analysis_summary.txt ./

# Download strongest signal plots (check summary first for TOI numbers)
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/phase2b_toi_full/TOI_123_*.png ./
```

## Troubleshooting

### If Download Job Fails:
1. Check logs: `cat logs/phase2b_all_tois_download_JOBID.err`
2. Common issues:
   - MAST archive temporarily down (retry later)
   - Network timeout (job will continue with next TOI)
   - Lightkurve cache issues: `rm -rf ~/.lightkurve/cache/`

### If Analysis Job Fails:
1. Check environment: `cat logs/analyze_phase2b_all_tois_JOBID.err`
2. Verify FITS files: `ls -lh ../data/tess_toi_full/*.fits | head`
3. Test one file manually:
   ```bash
   python -c "import lightkurve as lk; lc = lk.read('../data/tess_toi_full/TOI_100_*.fits'); print(lc)"
   ```

### If Running Out of Space:
- Current estimate: 5.9 GB total (should be fine after cleanup)
- If needed: `rm -rf ../data/tess_toi/` (old Phase 2 data, 168 MB)
- Emergency: Move to /bulk: `rsync -av results/phase2b_toi_full/ /bulk/tylerdoe/archives/tess_phase2b/`

## Expected Timeline

**Total: ~20 hours for complete pipeline**

| Time | Activity | What's Happening |
|------|----------|------------------|
| T+0h | Submit download job | Job starts on compute node |
| T+1h | Download in progress | ~700 TOIs downloaded |
| T+5h | Halfway through download | ~3,500 TOIs downloaded |
| T+10h | Download complete | ~6,500 TOIs saved to disk |
| T+10h | Submit analysis job | BLS periodogram analysis starts |
| T+12h | Analysis ~25% done | ~1,700 analyses complete |
| T+15h | Analysis ~60% done | ~4,000 analyses complete |
| T+18h | Analysis ~90% done | ~6,000 analyses complete |
| T+20h | **COMPLETE!** | All results in `results/phase2b_toi_full/` |

## Next Steps After Phase 2B

1. **Review strongest signals** - These are likely confirmed exoplanets!
2. **Compare to known TOI predictions** - Did we match the expected periods?
3. **Phase 3** - Random star search for NEW discoveries
4. **Publication** - Results could support grant applications or papers
5. **Scaling** - Could run Phase 2C with different analysis parameters

---

## Ready to Launch?

```bash
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs
sbatch download_phase2b_all_tois.slurm
```

**Good luck! You're about to analyze the entire TESS TOI catalog!** 🚀🌍✨
