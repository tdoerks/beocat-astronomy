# TESS Exoplanet Analysis - Current Session Status

**Date:** November 29, 2025
**Status:** 3 parallel download jobs running on Beocat

---

## 🚀 Currently Running Jobs

### Phase 1: Confirmed Exoplanets (Job 4319144)
- **Target:** 50 confirmed exoplanet host stars
- **Purpose:** Pipeline validation at scale
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess/`
- **Expected time:** ~5-10 minutes
- **Status:** RUNNING (started most recently)

### Phase 2: TOI Candidates (Job 4319138)
- **Target:** 200 unconfirmed TOI (TESS Objects of Interest) candidates
- **Purpose:** Scientific contribution - help validate potential new exoplanets
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_toi/`
- **Expected time:** ~30-60 minutes
- **Status:** RUNNING (59 seconds elapsed)

### Phase 3: Random Star Search (Job 4319139)
- **Target:** 1,000 random TESS-observed stars
- **Purpose:** Discovery mode - search for missed transits
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_random/`
- **Expected time:** Several hours (searches 5,000 random TIC IDs)
- **Status:** RUNNING (48 seconds elapsed)

---

## ✅ Completed Work

### Successful Initial Test (9 exoplanets)
- Downloaded and analyzed 9 confirmed exoplanets
- All 9 successfully detected with BLS periodogram
- Generated 18 PNG plots (analysis + phase-folded transits)
- Results in `/homes/tylerdoe/beocat-astronomy/results/`

**Detected periods matched known values:**
- Pi Mensae: 0.644 days (ultra-short period, power: 288,860!)
- WASP-18: 2.849 days
- L 98-59: 6.270 days
- HD 221416: 14.480 days
- And 5 more confirmed detections

### Fixed Analysis Pipeline
- Resolved lightkurve/astropy unit compatibility issues
- Fixed flux normalization (manual method to bypass unit errors)
- Fixed flux_err unit stripping
- Analysis script now works reliably: `scripts/analyze_tess_transits.py`

---

## 📊 Next Steps (When You Return)

### 1. Check Job Status
```bash
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs
squeue -u tylerdoe
```

### 2. Review Download Results

**Phase 1 (Confirmed):**
```bash
cat logs/download_4319144.out
ls -lh ../data/tess/
# Should have ~50 FITS files (~35-50 MB total)
```

**Phase 2 (TOI Candidates):**
```bash
cat logs/phase2_toi_4319138.out
ls -lh ../data/tess_toi/
# May have variable results depending on TOI catalog search
```

**Phase 3 (Random Search):**
```bash
cat logs/phase3_random_4319139.out
ls -lh ../data/tess_random/
# Will take longest - check periodically
```

### 3. Run Analysis on Downloaded Data

**Analyze Phase 1 (50 confirmed):**
```bash
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs

# Edit analyze_transits.slurm to use correct input directory
nano analyze_transits.slurm
# Change: python analyze_tess_transits.py -d ../data/tess -o ../results/phase1

sbatch analyze_transits.slurm
```

**Analyze Phase 2 (TOI candidates):**
```bash
# Create similar analysis job for TOI data
# Output to ../results/phase2_toi
```

**Analyze Phase 3 (Random stars):**
```bash
# Create analysis job for random star data
# Output to ../results/phase3_random
# THIS is where discoveries might happen!
```

### 4. Review Results

**Check for successful detections:**
```bash
cat ../results/phase1/analysis_summary.txt
cat ../results/phase2_toi/analysis_summary.txt
cat ../results/phase3_random/analysis_summary.txt
```

**Download plots to local machine:**
```bash
# From Windows/local machine:
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/phase*/*.png ./
```

### 5. Look for Interesting Results

**Phase 1:** Should match known exoplanet periods (validation)

**Phase 2:** TOI candidates that show strong transit signals could be:
- Confirmed exoplanets (you validated them!)
- False positives (eclipsing binaries, etc.)

**Phase 3:** ANY strong transit signal in random stars = potential NEW discovery!
- Look for high transit power values (>500)
- Check if period makes sense for planets (0.5-20 days)
- Compare against known exoplanet catalogs

---

## 🔧 Technical Notes

### Working Pipeline Components

**Download Scripts:**
- `scripts/download_tess_data.py` - Phase 1 (50 confirmed exoplanets)
- `scripts/download_tess_toi.py` - Phase 2 (200 TOI candidates)
- `scripts/download_tess_random.py` - Phase 3 (1,000 random stars)

**Analysis Script:**
- `scripts/analyze_tess_transits.py` - BLS periodogram transit detection
- **Key fix:** Manual flux normalization to bypass astropy unit issues
- Works on any TESS SPOC FITS files

**SLURM Jobs:**
- `download_data.slurm` - Phase 1 download
- `download_phase2_toi.slurm` - Phase 2 download
- `download_phase3_random.slurm` - Phase 3 download
- `analyze_transits.slurm` - Analysis job (needs input/output paths updated for each phase)

### Known Issues Resolved

1. ✅ **Unit compatibility:** Fixed by manual normalization
2. ✅ **flux_err units:** Stripped alongside flux
3. ✅ **Time formatting:** Use `.value` property
4. ✅ **FITS file reading:** Use `lk.read()` instead of `LightCurve.read()`

### Storage Usage

**Current:**
- Phase 1 test (9 targets): ~11 MB (6 MB data + 5 MB plots)
- Estimated Phase 1 (50 targets): ~60-80 MB
- Estimated Phase 2 (200 TOI): ~200-300 MB
- Estimated Phase 3 (1,000 random): ~1-1.5 GB

**Total estimated:** ~1.6-2 GB (well within /homes capacity after cleanup)

---

## 🎯 Scientific Goals

### Immediate Goals (This Session)
- ✅ Validate pipeline works at scale (Phase 1)
- ⏳ Contribute to TOI candidate validation (Phase 2)
- ⏳ Search for new/missed transits (Phase 3)

### Future Possibilities
1. **Grant Applications:** Use results for Planetary Society grant, NASA funding
2. **Publication:** If Phase 3 finds anything interesting
3. **Scaling:** Could run 10,000+ stars if storage allows
4. **Specialized Searches:**
   - Target specific star types (M dwarfs for habitable zone planets)
   - Look for circumbinary planets
   - Ultra-short period planets (<1 day)

---

## 📝 Commands Quick Reference

```bash
# Check job status
squeue -u tylerdoe

# View job output
cat logs/download_JOBID.out
cat logs/phase2_toi_JOBID.out
cat logs/phase3_random_JOBID.out

# Check downloaded data
ls -lh ../data/tess/
ls -lh ../data/tess_toi/
ls -lh ../data/tess_random/

# Submit analysis jobs
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs
sbatch analyze_transits.slurm

# Check disk usage
du -sh ../data/*
quota

# Download results to local machine (from Windows)
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/*.png ./
```

---

## 🐛 Troubleshooting

**If downloads fail:**
- Check logs: `cat logs/download_JOBID.err`
- Common issue: MAST archive temporarily unavailable (retry later)
- TOI search might fail if catalog format changed (fallback to TIC numbers)

**If analysis fails:**
- Check unit issues didn't resurface
- Verify FITS files are valid: `ls -lh ../data/tess/*.fits`
- Check lightkurve can read them: `python -c "import lightkurve as lk; lc = lk.read('file.fits')"`

**If running out of space:**
- Remove old test results: `rm -rf ../results/` (after backing up)
- Clear cache: `rm -rf ~/.lightkurve/cache/`
- Move results to `/bulk`: `rsync -av results/ /bulk/tylerdoe/archives/tess_results/`

---

## 💾 Data Cleanup (Earlier Today)

Freed up space in `/homes`:
- ✅ Removed `compass_kansas_results/` (497 GB) - backed up to `/bulk/tylerdoe/archives/`
- Current usage: 628 GB → ~131 GB after cleanup
- Plenty of room for TESS analysis results

---

## 🔗 Useful Links

- [Lightkurve Documentation](https://docs.lightkurve.org/)
- [TESS Mission Site](https://tess.mit.edu/)
- [TOI Catalog](https://exofop.ipac.caltech.edu/tess/)
- [NASA Exoplanet Archive](https://exoplanetarchive.ipac.caltech.edu/)

---

**Last Updated:** 2025-11-29 16:50 CST
**Next Action:** Check job status when you return, then run analysis on downloaded data!

Enjoy your meal! 🍽️
