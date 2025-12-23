# Publication & Sharing Guide - TESS Exoplanet Analysis

**Project:** Beocat TESS Exoplanet Transit Survey
**Scale:** ~44,000 TESS light curves analyzed
**Status:** Ready for result compilation and publication

---

## Overview

This guide covers three main pathways for sharing your exoplanet analysis results:

1. **Zenodo Dataset** (Easiest, immediate impact)
2. **Academic Papers** (Traditional peer review, higher prestige)
3. **TESS Follow-up Program** (Community validation, discovery confirmation)

Choose one or combine multiple approaches depending on your goals!

---

## Option 1: Zenodo Dataset Publication (Recommended First Step)

**Best for:** Quick sharing, citable DOI, community access
**Time:** 1-2 days
**Peer Review:** None required
**Impact:** Immediate, widely cited in data-driven astronomy

### Why Zenodo?

- Free, permanent, citable DOI
- Used extensively by astronomy community
- No peer review delays
- Can update with new versions
- Indexed by NASA ADS (Astrophysics Data System)

### What to Include:

**1. Compiled Results Files:**
```
results/
├── phase2b_toi_full_summary.csv         # ~7,000 TOI results
├── phase3_all_random_stars_compiled.csv # ~11,000 random star results
├── phase3_ultra_compiled.csv            # ~26,657 ULTRA results
└── combined_all_results.csv             # ALL ~44,000 stars
```

**2. Methodology Documentation:**
- Pipeline description (BLS algorithm, parameters)
- Data sources (TESS SPOC, FFI)
- Selection criteria
- Analysis parameters

**3. Summary Statistics:**
- Total stars analyzed
- Detection rates
- Top candidates (transit power > 10,000)

**4. README and LICENSE:**
- How to use the data
- Citation information
- CC-BY or CC0 license

### Steps to Publish on Zenodo:

1. **Compile all results:**
   ```bash
   cd /homes/tylerdoe/beocat-astronomy/scripts
   python compile_all_results.py  # Creates combined CSV
   ```

2. **Create metadata file** (see template below)

3. **Upload to Zenodo:**
   - Go to https://zenodo.org
   - Create account (can use ORCID)
   - Click "New Upload"
   - Upload files (can be large - Zenodo supports up to 50 GB per dataset)
   - Fill in metadata
   - Publish!

4. **Get DOI and cite in papers**

### Zenodo Metadata Template:

```yaml
Title: "TESS Exoplanet Transit Survey: 44,000 Star Analysis"

Description: |
  Comprehensive transit analysis of ~44,000 TESS light curves including:
  - 7,000 TESS Objects of Interest (TOI) validation
  - 37,000 random star search for undiscovered transits

  Methodology: Box Least Squares (BLS) periodogram
  Data Source: TESS 2-minute cadence and FFI
  Analysis Period: 2025

  Results include transit parameters, detection significance,
  and phase-folded light curves for all significant detections.

Keywords:
  - exoplanets
  - TESS
  - transit photometry
  - time series analysis
  - stellar variability

Creators:
  - Name: Tyler Doerksen
    Affiliation: Kansas State University
    ORCID: [your ORCID if you have one]

License: CC-BY-4.0

Related Publications:
  - [Add if you write a paper]
```

---

## Option 2: Academic Paper Publication

**Best for:** Traditional academic credit, peer validation
**Time:** 3-12 months
**Peer Review:** Yes
**Impact:** High prestige, career advancement

### Paper Type Options:

### 2A. Research Note (Fastest)

**Journal:** Research Notes of the American Astronomical Society (RNAAS)
**Length:** 1,000 words max (~2 pages)
**Peer Review:** Light (days to weeks)
**Cost:** Free (AAS member) or $100-200 (non-member)
**Best for:** Quick announcement of interesting findings

**Structure:**
```
Title: "Transit Analysis of 44,000 TESS Stars: Catalog and Notable Discoveries"

Abstract (150 words):
- Scale of survey
- Methodology
- Key findings
- Data availability

Body (~800 words):
1. Introduction (100 words)
   - TESS mission background
   - Motivation for large-scale random search

2. Methods (300 words)
   - Sample selection
   - BLS parameters
   - Quality cuts

3. Results (300 words)
   - Detection statistics
   - Notable candidates
   - Comparison with TOI catalog

4. Data Availability (100 words)
   - Zenodo DOI
   - GitHub repository

References (10-15)
```

**Submission:** https://journals.aas.org/rnaas/

### 2B. Full Research Article (More Impact)

**Journals:**
- *Monthly Notices of the Royal Astronomical Society* (MNRAS) - Free
- *The Astronomical Journal* (AJ) - $300-600
- *Astronomy & Computing* - Good for methodology papers

**Length:** 10-20 pages
**Peer Review:** 2-6 months
**Best for:** Detailed methodology, significant discoveries

**Structure:**
```
1. Abstract
2. Introduction
   - TESS overview
   - Previous large-scale surveys
   - Paper objectives

3. Data and Methods
   3.1 Sample Selection
   3.2 Data Reduction
   3.3 BLS Transit Search
   3.4 Vetting and False Positive Rejection

4. Results
   4.1 TOI Catalog Validation
   4.2 Random Star Survey Results
   4.3 Novel Transit Candidates
   4.4 Eclipsing Binary Discoveries

5. Discussion
   5.1 Comparison with Previous Surveys
   5.2 Detection Efficiency
   5.3 Astrophysical Implications

6. Conclusions
7. Data Availability
8. Acknowledgments
9. References
```

### 2C. Methodology/Techniques Paper

**Journal:** *Astronomy & Computing*
**Focus:** Pipeline development, computational methods
**Best for:** If you developed novel techniques

---

## Option 3: TESS Follow-up Observing Program (TFOP)

**Best for:** Confirming discoveries, community validation, co-authorship opportunities
**Website:** https://tess.mit.edu/followup/

### What is TFOP?

- Community-driven follow-up of TESS candidates
- Ground-based telescopes worldwide
- Can lead to confirmed exoplanet discoveries
- You can be listed as discoverer/contributor

### How to Submit Candidates:

1. **Identify strongest candidates:**
   ```bash
   # Get top 100 signals from random star search
   grep "Transit power:" results/phase3_ultra_analysis/analysis_summary.txt | \
     sort -t: -k2 -n | tail -100 > top_candidates.txt
   ```

2. **Cross-check against existing TOI catalog:**
   - Download TOI catalog: https://exofop.ipac.caltech.edu/tess/
   - Check if TIC IDs are already known
   - Focus on NEW discoveries

3. **Prepare candidate information:**
   - TIC ID
   - Transit parameters (period, depth, duration)
   - Transit power / significance
   - Phase-folded plot
   - Full light curve

4. **Submit via ExoFOP-TESS:**
   - Create account: https://exofop.ipac.caltech.edu/tess/
   - Submit Community TOI (CTOI)
   - Provide all details and plots

5. **Community will:**
   - Validate your detection
   - Perform follow-up observations
   - Confirm planet or rule out false positive
   - **You get co-authorship on discovery papers!**

---

## Recommended Publication Strategy

### Phase 1: Immediate (Now - 1 month)

**1. Compile results**
```bash
cd /homes/tylerdoe/beocat-astronomy/scripts
python compile_all_results.py
```

**2. Publish Zenodo dataset**
- Quick impact
- Get citable DOI
- Community access

**3. Identify top 50 candidates**
- Focus on random star discoveries (not in TOI catalog)
- Visual inspection of plots
- Cross-reference with SIMBAD, TOI catalog

### Phase 2: Short-term (1-3 months)

**1. Write RNAAS research note**
- Announce survey and dataset
- Highlight 5-10 most interesting candidates
- Cite Zenodo DOI
- Quick publication (~1 month review)

**2. Submit top candidates to TFOP**
- Community validation
- Potential follow-up observations
- Co-authorship opportunities

### Phase 3: Long-term (3-12 months)

**1. Full research article**
- After RNAAS establishes priority
- Include TFOP validation results
- Detailed analysis of discoveries
- Submit to MNRAS or AJ

**2. Continued follow-up**
- Monitor TFOP progress
- Participate in follow-up campaigns
- Co-author confirmation papers

---

## Required Analyses Before Publication

### 1. Result Compilation

**Combine all results into master catalog:**
```bash
cd /homes/tylerdoe/beocat-astronomy/scripts
python compile_all_results.py --output ../results/master_catalog.csv
```

**Master catalog should include:**
- TIC ID
- Transit parameters (period, depth, duration, epoch)
- Detection significance (transit power, SNR)
- Stellar parameters (magnitude, effective temp)
- Data quality metrics
- Notes (TOI match, possible EB, etc.)

### 2. Cross-Matching

**Check against known catalogs:**
- **TOI Catalog:** Already known TESS candidates
- **SIMBAD:** Known variable stars, binaries
- **Gaia DR3:** Stellar parameters, binarity indicators
- **Eclipsing Binary Catalogs:** Distinguish EBs from planets

**Python script:**
```python
import pandas as pd
from astroquery.simbad import Simbad
from astroquery.mast import Catalogs

# Load your results
results = pd.read_csv('master_catalog.csv')

# Query SIMBAD for each TIC ID
for tic in results['TIC_ID']:
    # Check if known variable, binary, etc.
    simbad_result = Simbad.query_objectids(f'TIC {tic}')
    # Add to results dataframe
```

### 3. Vetting Top Candidates

**For each strong signal (power > 10,000):**

1. **Visual inspection:**
   - Does transit shape look realistic?
   - Are transits consistent across all epochs?
   - Any obvious artifacts?

2. **Even-Odd transit check:**
   - Compare even vs odd transits
   - Identical depths = likely planet
   - Different depths = likely eclipsing binary

3. **Secondary eclipse check:**
   - Look for eclipse at phase 0.5
   - Present = likely eclipsing binary
   - Absent = likely planet

4. **Stellar contamination:**
   - Check Gaia for nearby stars
   - Could be blended eclipsing binary

### 4. Statistical Analysis

**Calculate survey completeness:**
- What fraction of known planets did you detect? (from Phase 1 & 2)
- Detection efficiency as function of period, depth
- Occurrence rate estimates

**Compare with literature:**
- How does your detection rate compare to TESS pipeline?
- Novel discoveries vs expected rate

---

## Data Package Checklist

Before publishing, ensure you have:

- [ ] **Master results catalog** (CSV format)
  - All ~44,000 stars
  - Transit parameters for all detections
  - Quality flags

- [ ] **Top candidates list** (top 100-500)
  - Sorted by detection significance
  - Cross-matched with known catalogs
  - Vetted plots included

- [ ] **Methodology documentation**
  - BLS parameters
  - Quality cuts
  - Sample selection

- [ ] **README file**
  - How to use the data
  - Column descriptions
  - Known issues/caveats

- [ ] **Summary statistics**
  - Total stars analyzed
  - Detection counts
  - Interesting subsets

- [ ] **LICENSE file**
  - Recommend CC-BY-4.0

- [ ] **Citation information**
  - How to cite your work
  - Zenodo DOI (once published)

---

## Example Citations

### Your Dataset (after Zenodo):
```
Doerksen, T. (2025). TESS Exoplanet Transit Survey: 44,000 Star Analysis.
Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX
```

### Your RNAAS Paper:
```
Doerksen, T. (2025). Transit Analysis of 44,000 TESS Stars:
Catalog and Notable Discoveries. Research Notes of the AAS, X, XXX.
```

### In Your Paper, Cite Key Tools:
```
- TESS Mission: Ricker et al. (2015)
- Lightkurve: Lightkurve Collaboration et al. (2018)
- Astropy: Astropy Collaboration et al. (2013, 2018)
- BLS Algorithm: Kovács et al. (2002)
```

---

## Timeline Estimate

| Task | Time | Milestone |
|------|------|-----------|
| Compile results | 1 day | Master catalog ready |
| Cross-match catalogs | 2-3 days | Known vs new identified |
| Visual vetting | 1 week | Top 50 candidates selected |
| Zenodo upload | 1 day | Dataset published, DOI obtained |
| Write RNAAS note | 1 week | Draft complete |
| RNAAS review | 2-4 weeks | Paper published |
| TFOP submissions | Ongoing | Community validation |
| Full paper draft | 1-2 months | Detailed analysis |
| Full paper review | 2-6 months | Major publication |

---

## Resources & Links

### Data Archives:
- **MAST (TESS data):** https://mast.stsci.edu/
- **ExoFOP-TESS:** https://exofop.ipac.caltech.edu/tess/
- **NASA Exoplanet Archive:** https://exoplanetarchive.ipac.caltech.edu/

### Catalogs:
- **TOI Catalog:** https://tess.mit.edu/toi-releases/
- **SIMBAD:** http://simbad.u-strasbg.fr/simbad/
- **Gaia Archive:** https://gea.esac.esa.int/archive/

### Publication Venues:
- **RNAAS:** https://journals.aas.org/rnaas/
- **MNRAS:** https://academic.oup.com/mnras
- **The Astronomical Journal:** https://iopscience.iop.org/journal/1538-3881
- **Astronomy & Computing:** https://www.journals.elsevier.com/astronomy-and-computing

### Community:
- **TFOP:** https://tess.mit.edu/followup/
- **Zooniverse Planet Hunters TESS:** https://www.zooniverse.org/projects/nora-dot-eisner/planet-hunters-tess
- **Exoplanet Reddit:** https://www.reddit.com/r/Exoplanets/

---

## Questions to Consider

Before publishing, think about:

1. **What's your main finding?**
   - "We found X new planet candidates"
   - "We validated the TOI catalog with independent analysis"
   - "We demonstrated feasibility of large-scale amateur surveys"

2. **What's novel about your work?**
   - Scale (44,000 stars)
   - Random star search (not pre-selected targets)
   - Independent validation of TOI catalog

3. **Who's your audience?**
   - Professional astronomers? → Full paper in MNRAS
   - Data users? → Zenodo + documentation
   - Exoplanet community? → TFOP submissions

4. **What are your goals?**
   - Quick impact? → Zenodo + RNAAS
   - Career advancement? → Full peer-reviewed paper
   - Discovery credit? → TFOP + follow-up

---

## Next Steps - Summary

**Right now (Week 1):**
1. Monitor Phase 3 ULTRA analysis completion
2. Start compiling results into master catalog
3. Begin cross-matching with TOI catalog

**Week 2-3:**
4. Visual vetting of top 100 candidates
5. Prepare Zenodo upload package
6. Draft RNAAS research note

**Month 2:**
7. Publish Zenodo dataset (get DOI)
8. Submit RNAAS paper
9. Submit top 10-20 candidates to TFOP

**Months 3-6:**
10. Respond to TFOP feedback
11. Begin full research article
12. Monitor for follow-up observations

**You're doing publication-worthy science!** 🌟🔭

Your 44,000-star survey is unprecedented for an individual researcher. This is genuinely impactful work that the exoplanet community will value.

---

**Questions?** Check the PIPELINE_GUIDE.md for technical details, or consult:
- TESS Science Support Center: https://heasarc.gsfc.nasa.gov/docs/tess/
- Exoplanet Explorers Community: https://www.zooniverse.org/projects/ianc2/exoplanet-explorers

**Good luck with your discoveries!** 🪐
