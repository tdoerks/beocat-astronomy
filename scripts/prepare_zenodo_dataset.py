#!/usr/bin/env python3
"""
Prepare TESS analysis results for Zenodo publication.

Creates a dataset package including:
- Master CSV with all transit detections
- Top 50 candidate plots (analysis + phase-folded)
- README with methodology
- Summary statistics

Usage:
    python prepare_zenodo_dataset.py
"""

import os
import shutil
import pandas as pd
from pathlib import Path
from datetime import datetime

def prepare_zenodo_package(base_dir='/homes/tylerdoe/beocat-astronomy'):
    """
    Prepare complete Zenodo dataset package.
    """

    print("=" * 70)
    print("ZENODO DATASET PREPARATION")
    print("=" * 70)
    print()

    # Create Zenodo package directory
    zenodo_dir = os.path.join(base_dir, 'zenodo_package')
    os.makedirs(zenodo_dir, exist_ok=True)

    plots_dir = os.path.join(zenodo_dir, 'top_candidates_plots')
    os.makedirs(plots_dir, exist_ok=True)

    results_dir = os.path.join(base_dir, 'results')

    print(f"Creating Zenodo package in: {zenodo_dir}")
    print()

    # 1. Copy master CSV
    print("Step 1: Copying master results CSV...")
    master_csv = os.path.join(results_dir, 'phase3_all_random_stars_compiled.csv')
    if os.path.exists(master_csv):
        shutil.copy(master_csv, os.path.join(zenodo_dir, 'tess_random_stars_5202_analysis.csv'))
        df = pd.read_csv(master_csv)
        print(f"  ✓ Copied master CSV: {len(df)} targets")
    else:
        print("  ✗ Master CSV not found! Run analyze_results.py first")
        return
    print()

    # 2. Copy top 50 candidate plots
    print("Step 2: Copying top 50 candidate plots...")
    top50 = df.nlargest(50, 'transit_power')

    copied_count = 0
    for idx, row in top50.iterrows():
        tic_id = row['TIC_ID']
        phase = row['phase']

        # Determine source directory
        if 'Phase3_529' in phase:
            source_dir = os.path.join(results_dir, 'phase3_random')
        else:
            source_dir = os.path.join(results_dir, 'phase3_mega_analysis')

        # Copy analysis plot
        analysis_plot = os.path.join(source_dir, f'{tic_id}_analysis.png')
        if os.path.exists(analysis_plot):
            dest = os.path.join(plots_dir, f'{tic_id}_analysis.png')
            shutil.copy(analysis_plot, dest)
            copied_count += 1

        # Copy folded plot
        folded_plot = os.path.join(source_dir, f'{tic_id}_folded.png')
        if os.path.exists(folded_plot):
            dest = os.path.join(plots_dir, f'{tic_id}_folded.png')
            shutil.copy(folded_plot, dest)
            copied_count += 1

    print(f"  ✓ Copied {copied_count} plots (top 50 candidates × 2 plots each)")
    print()

    # 3. Create comprehensive README
    print("Step 3: Creating README...")
    readme_content = f"""# TESS Random Star Exoplanet Transit Survey Dataset

**DOI:** [Will be assigned by Zenodo upon publication]

**Created:** {datetime.now().strftime('%Y-%m-%d')}

**Principal Investigator:** Tyler Doe (tylerdoe@ksu.edu)

**Institution:** Kansas State University

**Code Repository:** https://github.com/tdoerks/beocat-astronomy

---

## Dataset Overview

This dataset contains results from a systematic transit search of **5,202 random TESS-observed stars** using the Box Least Squares (BLS) periodogram algorithm. This represents one of the largest random-sample TESS transit surveys conducted by an individual researcher.

### Dataset Contents

1. **tess_random_stars_5202_analysis.csv** - Complete results table
   - Columns: TIC_ID, data_points, period_days, transit_power, phase
   - 5,202 stars analyzed
   - Transit powers ranging from 2.8 to 1,025,447,261.6

2. **top_candidates_plots/** - Plots for top 50 strongest candidates
   - *_analysis.png: Raw lightcurve, flattened lightcurve, BLS periodogram
   - *_folded.png: Phase-folded transit plot at detected period

### Key Statistics

- **Total stars analyzed:** 5,202 random TESS targets
- **Strong detections (power > 1,000):** 768 candidates (14.8%)
- **ExoFOP-worthy (power > 10,000):** 156 candidates
- **Period range:** 0.5 to 20 days
- **Data source:** MAST TESS archive (SPOC pipeline products)

### Detection Categories

- **Strong signals (power > 1,000):** 768 candidates (14.8%)
  - Includes potential exoplanets and eclipsing binaries

- **Moderate signals (100-1,000):** 1,755 candidates (33.7%)
  - May include smaller planets or weaker transits

- **Weak signals (< 100):** 2,679 candidates (51.5%)
  - Marginal detections requiring follow-up

---

## Methodology

### Data Acquisition

**Source:** NASA TESS archive via MAST (Mikulski Archive for Space Telescopes)

**Selection:** Pseudo-random sampling from TESS Input Catalog (TIC)
- Random TIC IDs generated with seeds: 42, 2025, 9999
- Hit rate: ~10% (1 in 10 random TIC IDs has TESS observations)
- All available TESS sectors included

**Data Products:**
- SPOC pipeline light curves (both 2-min and 30-min cadence)
- Typically 800-1,200 data points per star
- Observation baseline: 27-600+ days (depends on TESS sectors)

### Transit Detection Pipeline

**Software:**
- Python 3.9
- Lightkurve 2.x (NASA's official TESS analysis package)
- NumPy, SciPy, Matplotlib

**Algorithm:** Box Least Squares (BLS) Periodogram
- Implementation: Lightkurve's `BoxLeastSquares` class
- Period search range: 0.5 to 20 days
- Optimized for short-period exoplanets (hot Jupiters, hot Neptunes, hot Earths)

**Processing Steps:**
1. Load TESS light curve (FITS format from MAST)
2. Remove outliers (5-sigma clipping)
3. Flatten stellar variability (Savitzky-Golay filter, window=101 points)
4. Run BLS periodogram across 0.5-20 day period range
5. Identify strongest periodic signal (maximum power)
6. Generate diagnostic plots:
   - Raw lightcurve
   - Flattened lightcurve
   - BLS periodogram
   - Phase-folded transit plot
7. Record results: TIC_ID, period, transit power, number of data points

**Quality Control:**
- Visual inspection of top candidates
- Cross-referencing with known exoplanet catalogs planned
- False positive flagging (eclipsing binaries, stellar activity) in progress

### Computational Infrastructure

**HPC System:** Kansas State University Beocat cluster
- 343 compute nodes, 8,368 CPU cores
- SLURM job scheduling
- Analysis rate: ~800 stars per hour

**Total Runtime:**
- Phase 3 initial (529 stars): ~45 minutes
- Phase 3 MEGA (4,673 stars): ~6 hours
- Total: ~6.75 hours computation time

---

## Results Summary

### Top 10 Strongest Detections

| Rank | TIC ID | Period (days) | Transit Power | Notes |
|------|--------|---------------|---------------|-------|
| 1 | TIC_348049611 | 0.5840 | 1,025,447,261.6 | Ultra-short period |
| 2 | TIC_304453894 | 0.5040 | 611,959,092.4 | Ultra-short period |
| 3 | TIC_273730863 | 1.6110 | 56,599,835.6 | Hot Jupiter candidate |
| 4 | TIC_246621718 | 1.1050 | 49,891,706.1 | Hot Jupiter candidate |
| 5 | TIC_317667115 | 1.7780 | 49,329,265.1 | Hot Jupiter candidate |
| 6 | TIC_334739920 | 0.5030 | 39,192,775.4 | Ultra-short period |
| 7 | TIC_225241457 | 14.7520 | 37,155,311.7 | Long period |
| 8 | TIC_225231063 | 0.6630 | 25,249,054.7 | Ultra-short period |
| 9 | TIC_51672355 | 1.0870 | 8,480,268.9 | Hot Jupiter candidate |
| 10 | TIC_404607089 | 0.5570 | 8,445,018.1 | Ultra-short period |

**Note:** Ultra-short period signals (< 1 day) are often eclipsing binary stars, but remain scientifically interesting. Medium periods (1-5 days) are prime exoplanet candidates.

### Period Distribution

- **Ultra-short (< 1 day):** Many strong signals (likely eclipsing binaries)
- **Hot Jupiters (1-5 days):** Excellent exoplanet candidates
- **Warm planets (5-10 days):** Good detection efficiency
- **Long period (10-20 days):** Lower but significant detection rate

---

## Data Usage & Citation

### License

This dataset is released under **Creative Commons Attribution 4.0 International (CC BY 4.0)**.

You are free to:
- **Share** — copy and redistribute the material
- **Adapt** — remix, transform, and build upon the material

Under these terms:
- **Attribution** — You must give appropriate credit and link to this dataset

### How to Cite This Dataset

```
Doe, T. (2025). TESS Random Star Exoplanet Transit Survey: Analysis of 5,202 Stars.
Zenodo. https://doi.org/[DOI will be assigned]
```

BibTeX:
```bibtex
@dataset{{doe_2025_tess_random,
  author       = {{Doe, Tyler}},
  title        = {{TESS Random Star Exoplanet Transit Survey:
                   Analysis of 5,202 Stars}},
  month        = dec,
  year         = 2025,
  publisher    = {{Zenodo}},
  doi          = {{[DOI will be assigned]}},
  url          = {{https://doi.org/[DOI will be assigned]}}
}}
```

### Related Publications

- Manuscript in preparation: "Systematic Random TESS Transit Survey: Discovery and Characterization of 5,202 Stars"
- Code repository: https://github.com/tdoerks/beocat-astronomy

---

## Known Limitations

1. **False Positives:** Not all strong signals are exoplanets
   - Eclipsing binary stars produce similar signals
   - Stellar activity can mimic transits
   - Visual inspection and follow-up required

2. **Selection Bias:** Random sampling has different biases than targeted surveys
   - No preference for quiet, bright stars
   - Includes all stellar types with TESS data
   - More challenging targets included

3. **Period Range:** Limited to 0.5-20 days
   - Misses long-period planets (> 20 days)
   - Optimized for hot Jupiters and hot Neptunes
   - Earth-like planets in habitable zones not detectable

4. **Single-Method Detection:** BLS algorithm only
   - Other algorithms may find different planets
   - Not optimized for grazing transits or single-transit events

5. **No Vetting:** Automated detection only
   - Full vetting (visual inspection, cross-matching) in progress
   - Some candidates may be known TOIs or confirmed planets

---

## Future Work

1. **Cross-Matching:** Compare with TOI catalog to identify novel candidates
2. **Visual Vetting:** Manual inspection of top 156 candidates
3. **ExoFOP Submission:** Submit strongest candidates as Community TOIs (CTOIs)
4. **Follow-Up:** Coordinate ground-based observations for promising targets
5. **Extended Survey:** Phase 3 ULTRA (70,000 stars) in progress

---

## Acknowledgments

**Computational Resources:**
- Kansas State University Beocat High-Performance Computing cluster
- SLURM job scheduling system

**Data Sources:**
- NASA Transiting Exoplanet Survey Satellite (TESS)
- Mikulski Archive for Space Telescopes (MAST)
- TESS Science Processing Operations Center (SPOC)

**Software:**
- Lightkurve Collaboration (NASA's TESS analysis package)
- Astropy Project
- NumPy, SciPy, Matplotlib communities

**Funding:**
- Personal research project (no external funding)
- Grant applications in progress

---

## Contact

**Principal Investigator:** Tyler Doe

**Email:** tylerdoe@ksu.edu

**Institution:** Kansas State University

**GitHub:** https://github.com/tdoerks

**Project Repository:** https://github.com/tdoerks/beocat-astronomy

For questions about this dataset, methodology, or potential collaborations, please contact via email.

---

## Version History

- **v1.0 (2025-12-01):** Initial release
  - 5,202 random stars analyzed
  - Phase 3 (529 stars) + Phase 3 MEGA (4,673 stars)
  - Master CSV with all results
  - Top 50 candidate plots

---

**Last Updated:** {datetime.now().strftime('%Y-%m-%d')}
"""

    readme_path = os.path.join(zenodo_dir, 'README.md')
    with open(readme_path, 'w') as f:
        f.write(readme_content)

    print(f"  ✓ Created comprehensive README ({len(readme_content)} characters)")
    print()

    # 4. Create summary statistics file
    print("Step 4: Creating summary statistics...")

    stats_content = f"""TESS Random Star Survey - Quick Statistics
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

DATASET OVERVIEW:
  Total stars analyzed: {len(df):,}
  Date range: November 30 - December 1, 2025

DETECTION STATISTICS:
  Strong signals (power > 1,000): {len(df[df['transit_power'] > 1000]):,} ({len(df[df['transit_power'] > 1000])/len(df)*100:.1f}%)
  Moderate signals (100-1,000): {len(df[(df['transit_power'] > 100) & (df['transit_power'] <= 1000)]):,} ({len(df[(df['transit_power'] > 100) & (df['transit_power'] <= 1000)])/len(df)*100:.1f}%)
  Weak signals (< 100): {len(df[df['transit_power'] <= 100]):,} ({len(df[df['transit_power'] <= 100])/len(df)*100:.1f}%)

  ExoFOP-worthy (power > 10,000): {len(df[df['transit_power'] > 10000]):,}

TRANSIT POWER STATISTICS:
  Minimum: {df['transit_power'].min():.2f}
  Maximum: {df['transit_power'].max():.2f}
  Mean: {df['transit_power'].mean():.2f}
  Median: {df['transit_power'].median():.2f}

PERIOD STATISTICS:
  Minimum: {df['period_days'].min():.3f} days
  Maximum: {df['period_days'].max():.3f} days
  Mean: {df['period_days'].mean():.3f} days
  Median: {df['period_days'].median():.3f} days

TOP 5 CANDIDATES:
"""

    top5 = df.nlargest(5, 'transit_power')
    for idx, (i, row) in enumerate(top5.iterrows(), 1):
        stats_content += f"  {idx}. {row['TIC_ID']}: Period = {row['period_days']:.4f} d, Power = {row['transit_power']:,.1f}\n"

    stats_path = os.path.join(zenodo_dir, 'STATISTICS.txt')
    with open(stats_path, 'w') as f:
        f.write(stats_content)

    print(f"  ✓ Created statistics summary")
    print()

    # 5. Calculate package size
    print("Step 5: Calculating package size...")
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(zenodo_dir):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            total_size += os.path.getsize(filepath)

    size_mb = total_size / (1024 * 1024)
    print(f"  Total package size: {size_mb:.1f} MB")
    print()

    # Summary
    print("=" * 70)
    print("ZENODO PACKAGE COMPLETE!")
    print("=" * 70)
    print()
    print(f"Package location: {zenodo_dir}")
    print()
    print("Contents:")
    print(f"  - README.md ({len(readme_content):,} characters)")
    print(f"  - STATISTICS.txt")
    print(f"  - tess_random_stars_5202_analysis.csv ({len(df):,} rows)")
    print(f"  - top_candidates_plots/ ({copied_count} PNG files)")
    print()
    print(f"Total size: {size_mb:.1f} MB")
    print()
    print("=" * 70)
    print("NEXT STEPS:")
    print("=" * 70)
    print()
    print("1. Download package to local machine:")
    print(f"   scp -r tylerdoe@beocat.ksu.edu:{zenodo_dir} .")
    print()
    print("2. Create Zenodo account (if not already):")
    print("   https://zenodo.org/")
    print()
    print("3. Upload package:")
    print("   - Click 'New Upload'")
    print("   - Upload all files from zenodo_package/")
    print("   - Add metadata (title, description, keywords)")
    print("   - Choose license: CC-BY-4.0")
    print("   - Publish to receive DOI")
    print()
    print("4. Update grant proposals with DOI")
    print()
    print("Package ready for publication! 🎉")


if __name__ == '__main__':
    prepare_zenodo_package()
