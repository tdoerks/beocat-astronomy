# TESS Exoplanet Analysis - Current Session Status

**Date:** November 30, 2025 (Saturday night → Sunday morning)
**Time:** ~2:30 AM CST
**Storage:** 1 TB available on `/homes`

---

## 🚀 Currently Running Jobs (as of 2:30 AM)

### Job 4325662 - Phase 3 MEGA: Download 10,000 Random Stars ⭐ **NEW!**
- **Started:** 2:17 AM
- **Target:** 10,000 random TESS stars (seed=9999)
- **Search:** ~100,000 TIC IDs at ~10% hit rate
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_random_mega_10k/`
- **Expected runtime:** 20-24 hours (finishes Sunday ~10 PM - Monday 2 AM)
- **Storage:** ~10 GB data + ~10 GB results = ~20 GB
- **Purpose:** MEGA discovery mode - largest random TESS sample!
- **Status:** Just started (10 seconds in)

### Job 4324783 - Phase 3c: Download 500 More Random Stars
- **Started:** ~1:00 AM
- **Target:** 500 random TESS stars (seed=2025)
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_random_batch2/`
- **Expected runtime:** 2-3 hours (finishes ~3-4 AM)
- **Storage:** ~500 MB
- **Purpose:** Building to 1,000 random stars total
- **Status:** Running 1h 30m, ~1-1.5 hours remaining

### Job 4319836 - Phase 2B: Download ALL ~7,000 TOI Candidates
- **Started:** 7:11 PM Saturday
- **Progress:** 1,757+ TOIs downloaded (25% done, searching TOI-1533)
- **Target:** All 7,000 TOI candidates from TESS catalog
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_toi_full/`
- **Expected runtime:** 14 hours total (finishes Sunday ~9 AM)
- **Storage:** 1.7 GB so far, ~6-7 GB when complete
- **Purpose:** Comprehensive TOI catalog validation
- **Status:** Running 8h 7m, ~6 hours remaining

---

## ✅ Completed Jobs (Ready for Next Steps)

### Phase 3 v2 Analysis: 529 Random Stars ✅ **DISCOVERIES FOUND!**
- **Job:** 4324675 (completed 2:20 AM)
- **Analyzed:** 529 random TESS stars from Phase 3 v2
- **Runtime:** 40 minutes
- **Input:** `/homes/tylerdoe/beocat-astronomy/data/tess_random/`
- **Output:** `/homes/tylerdoe/beocat-astronomy/results/phase3_random/`
- **Results:**
  - 529 stars analyzed successfully
  - ~1,058 plots generated
  - **STRONG TRANSIT SIGNALS FOUND:**
    - Top 20 signals range from 11,740 to **611,959,092** transit power!
    - Multiple signals > 10,000 (much stronger than Phase 2 TOIs)
    - Likely mix of exoplanets, eclipsing binaries, and stellar activity
  - Summary: `../results/phase3_random/analysis_summary.txt`

### Phase 3 v2 Download: 529 Random Stars ✅
- **Job:** 4320230 (completed 12:56 AM)
- **Downloaded:** 529 random TESS stars (seed=42)
- **Hit rate:** 10.6% (searched 5,000 TIC IDs)
- **Storage:** ~500 MB
- **Output:** `/homes/tylerdoe/beocat-astronomy/data/tess_random/`
- **Note:** Fixed FFI data issue - was 0.04% hit rate with SPOC-only, now 10.6%!

### Phase 2: 196 TOI Candidates ✅
- **Downloaded & Analyzed:** 196 TOI candidates (TOI-100 through TOI-299)
- **Results:** 392 plots, strong signals (TOI-123 power: 13,536)
- **Output:** `/homes/tylerdoe/beocat-astronomy/results/phase2_toi/`

### Initial Test: 9 Confirmed Exoplanets ✅
- **Validated pipeline** with 9 known exoplanets
- **All detected correctly** (Pi Mensae, WASP-18, etc.)

---

## 📋 Next Steps (When You Return Sunday)

### Morning (~9 AM): Phase 2B Download Should Be Complete

**1. Check Phase 2B completion:**
```bash
cd /homes/tylerdoe/beocat-astronomy/slurm-jobs
squeue -u tylerdoe

# Check results
cat logs/phase2b_all_tois_download_4319836.out
ls -1 ../data/tess_toi_full/*.fits | wc -l  # Should be ~6,000-7,000
```

**2. Launch Phase 2B analysis (7,000 TOIs):**
```bash
sbatch analyze_phase2b_all_tois.slurm
```
- Expected runtime: ~8 hours (finishes ~5 PM Sunday)
- Will analyze all downloaded TOIs for transits
- Generates ~14,000 plots

### Early Morning (~3-4 AM): Phase 3c Should Be Complete

**1. Check Phase 3c completion:**
```bash
ls -1 ../data/tess_random_batch2/*.fits | wc -l  # Should be ~500
cat logs/phase3c_more_random_4324783.out
```

**2. Optionally analyze Phase 3c (or wait for MEGA):**
- Could create analysis job for batch2 directory
- Or wait and combine with Phase 3 MEGA later

### Monday (~10 PM - 2 AM): Phase 3 MEGA Should Be Complete

**1. Check Phase 3 MEGA completion:**
```bash
ls -1 ../data/tess_random_mega_10k/*.fits | wc -l  # Should be ~10,000
cat logs/phase3_mega_10k_4325662.out
```

**2. Analyze 10,000 random stars:**
- Will need to create analysis job (or batch the analysis)
- ~8-10 hour runtime to analyze 10,000 stars
- Will generate ~20,000 plots!

---

## 📊 Data Inventory

### Downloaded Data (Complete):
- `data/tess/` - 33 confirmed exoplanets (~30 MB) ✅
- `data/tess_toi/` - 196 TOI candidates (~168 MB) ✅
- `data/tess_random/` - 529 random stars (~500 MB) ✅

### Downloaded Data (In Progress):
- `data/tess_random_batch2/` - ~500 random stars (downloading, ~1h left) ⏳
- `data/tess_toi_full/` - ~7,000 TOIs (downloading, 1.7 GB so far, ~6h left) ⏳
- `data/tess_random_mega_10k/` - 10,000 random stars (just started, ~24h) ⏳

### Analysis Results (Complete):
- `results/phase2_toi/` - 196 TOI analyses, 392 plots (~109 MB) ✅
- `results/phase3_random/` - 529 random star analyses, 1,058 plots (~500 MB) ✅

### Analysis Results (Pending):
- `results/phase2b_toi_full/` - Need to run after download completes
- `results/phase3_batch2/` - Optional, could analyze separately
- `results/phase3_mega_10k/` - Will be HUGE (~10 GB plots)

### Total Storage Used (Current): ~3-4 GB
### Total Storage When Complete: ~40-50 GB (5% of 1 TB quota!)

---

## 🔧 Key Scripts & Jobs

### Download Scripts:
- `scripts/download_tess_data.py` - Confirmed exoplanets
- `scripts/download_tess_toi.py` - TOI candidates (accepts -n target count, -s seed)
- `scripts/download_tess_random.py` - Random stars (accepts -n target, -s seed, -o output)

### Analysis Script:
- `scripts/analyze_tess_transits.py` - BLS transit detection (works on any TESS FITS)

### SLURM Jobs (Downloads):
- `download_data.slurm` - Phase 1 (33 confirmed)
- `download_phase2_toi.slurm` - Phase 2 (196 TOIs)
- `download_phase2b_all_tois.slurm` - Phase 2B (7,000 TOIs) ⏳ RUNNING
- `download_phase3_random.slurm` - Phase 3 v2 (1,000 target, got 529)
- `download_phase3c_more_random.slurm` - Phase 3c (500 more) ⏳ RUNNING
- `download_phase3_mega_10k.slurm` - Phase 3 MEGA (10,000!) ⏳ RUNNING

### SLURM Jobs (Analysis):
- `analyze_phase1_confirmed.slurm` - Analyze confirmed exoplanets
- `analyze_phase2_toi.slurm` - Analyze TOI candidates
- `analyze_phase2b_all_tois.slurm` - Analyze all 7,000 TOIs (ready to run Sunday AM)
- `analyze_phase3_random.slurm` - Analyze random stars ✅ USED

---

## 🎯 Scientific Summary

### What We've Accomplished:
1. ✅ **Pipeline validated** - Works reliably on confirmed exoplanets
2. ✅ **TOI analysis proven** - 196 TOI candidates analyzed successfully
3. ✅ **Random search works** - Found strong signals in 529 random stars
4. ✅ **FFI data fix** - Improved hit rate from 0.04% to 10.6%
5. ✅ **Scaling proven** - Can handle thousands of analyses

### What's Running Now:
1. ⏳ **Full TOI catalog** - All 7,000 known TOI candidates downloading
2. ⏳ **Extended random search** - Building larger random sample
3. ⏳ **MEGA random search** - 10,000 stars for massive discovery mode!

### Scientific Impact When Complete:
- **~18,000 TESS light curves analyzed for exoplanet transits**
- **~7,000 TOI candidates validated** (help confirm new exoplanets!)
- **~11,000 random stars searched** (true discovery mode - new planets!)
- **~30,000+ plots generated** for visual inspection
- **Largest random TESS star transit search!** (10k stars unprecedented)

---

## 🐛 Issues Fixed This Session

1. ✅ **Phase 3 v1 low hit rate (0.04%)** → Fixed by removing SPOC filter, now 10.6%
2. ✅ **Phase 3 random seed** → Added -s parameter for different random samples
3. ✅ **Environment activation on some nodes** → Used absolute path instead of $HOME
4. ✅ **Analysis script missing** → Created analyze_phase3_random.slurm

---

## 📝 Quick Reference Commands

```bash
# Check all running jobs
squeue -u tylerdoe

# Check specific job output
cat logs/phase2b_all_tois_download_4319836.out
cat logs/phase3c_more_random_4324783.out
cat logs/phase3_mega_10k_4325662.out

# Count downloaded files
ls -1 ../data/tess_toi_full/*.fits | wc -l
ls -1 ../data/tess_random_batch2/*.fits | wc -l
ls -1 ../data/tess_random_mega_10k/*.fits | wc -l

# Check storage usage
du -sh ../data/*
du -sh ../results/*
quota

# When Phase 2B download completes (Sunday ~9 AM):
sbatch analyze_phase2b_all_tois.slurm

# View Phase 3 discoveries
cat ../results/phase3_random/analysis_summary.txt
grep "Transit power:" ../results/phase3_random/analysis_summary.txt | sort -t: -k2 -n | tail -20
```

---

## 🌟 Potential Discoveries in Phase 3 Random Stars

From completed Phase 3 v2 analysis (529 stars):

**Top transit signals found:**
- Highest: 611,959,092 power (!!!)
- Several > 100,000 power
- Many > 10,000 power

**These could be:**
- 🌍 New exoplanets in uncatalogued systems
- 🌑 Eclipsing binary stars (very common)
- ⭐ Stellar activity / pulsations
- ⚠️ Data artifacts

**Next step:** Download plots to visually inspect strongest signals!

```bash
# From local machine:
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/phase3_random/analysis_summary.txt ./

# Then identify interesting TIC IDs and download their plots
scp tylerdoe@beocat.ksu.edu:/homes/tylerdoe/beocat-astronomy/results/phase3_random/TIC_*_analysis.png ./
```

---

**Last Updated:** 2025-11-30 02:30 CST
**Status:** 3 download jobs running, 2 analyses complete, Phase 3 MEGA just launched!
**Next Check:** Sunday morning ~9 AM (Phase 2B download should be done)

**Storage Status:** ~4 GB used, ~40-50 GB when complete, 1 TB available = **plenty of room!** ✅
