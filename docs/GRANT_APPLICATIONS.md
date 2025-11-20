# Grant Application Guide

Using this HPC astronomy work to apply for research grants.

## Why This Work Supports Grant Applications

Having demonstrated HPC computational astronomy experience is a strong asset for:

1. **Shows technical capability:** You can handle large datasets
2. **Infrastructure access:** Beocat HPC already available
3. **Preliminary results:** Your analyses become "preliminary data"
4. **Publication potential:** Results can lead to papers/co-authorship

## Recommended Grant Targets

### 1. Planetary Society Shoemaker NEO Grant

**Amount:** $8,000 - $12,500
**Focus:** Near-Earth Object detection and characterization
**Deadline:** Annual (typically summer)
**Website:** planetary.org/shoemaker-grant

**How your work applies:**
- Adapt TESS analysis to asteroid photometry
- Use HPC for automated astrometry pipeline
- Propose telescope upgrade for NEO observations

**Application strategy:**
```
Proposal: "HPC-Accelerated Pipeline for Automated NEO Characterization"

Key points:
- Access to Beocat HPC (8,368 cores, 102 GPUs)
- Demonstrated experience processing TESS data
- Will develop ML classifier for NEO light curve analysis
- Request: $10,000 for camera upgrade + travel to observatory
```

### 2. NASA Citizen Science Seed Funding

**Amount:** Varies (typically $20k-50k)
**Focus:** Developing citizen science projects
**Deadline:** January 22, 2026 (ROSES-25 F.9)
**Website:** science.nasa.gov/citizen-science

**How your work applies:**
- Partner with university researcher (PI)
- You provide computational infrastructure & expertise
- Develop public-facing transit detection project

**Application strategy:**
```
Proposal: "Distributed Exoplanet Transit Detection Network"

Your role: Co-Investigator / Technical Lead
- HPC backend for processing amateur astronomer data
- Machine learning pipeline for automated validation
- Web interface for citizen scientists to submit observations

Budget: Your time + HPC compute allocation
```

### 3. Mt. Cuba Astronomical Foundation

**Amount:** $5,000 - $250,000
**Focus:** Astronomical research projects
**Deadline:** Rolling
**Website:** mtcubaastrofnd.org

**How your work applies:**
- Fund observatory equipment
- Support large-scale photometric surveys
- Develop new analysis techniques

**Application strategy:**
```
Proposal: "Time-Domain Astronomy Survey with HPC Analysis"

Request: $50,000
- $30k: Telescope + wide-field camera
- $10k: Observatory automation
- $10k: Travel + operations

Highlight: Computational infrastructure already in place (Beocat)
          Only need observational equipment
```

### 4. NSF Astronomy & Astrophysics Research Grants (AAG)

**Amount:** $50,000 - $500,000
**Focus:** Collaborative research projects
**Deadline:** November 17 annually
**Website:** nsf.gov/funding/opportunities/aag

**How your work applies:**
- Collaborate with university faculty (required)
- You provide computational expertise
- Larger, multi-year research programs

**Application strategy:**
```
Partner with K-State astronomy faculty or nearby university

Your contribution:
- HPC analysis pipelines
- Machine learning model development
- Large-scale data processing

Faculty contribution:
- Scientific oversight
- Theoretical framework
- Graduate student mentoring
```

## Building Your Grant Application

### Components You Already Have

From this Beocat work:

- ✅ **Computational Resources:** "Access to 8,368-core HPC cluster with 102 GPUs"
- ✅ **Technical Skills:** "Demonstrated experience with TESS data analysis"
- ✅ **Software Infrastructure:** "Developed automated transit detection pipeline"
- ✅ **Preliminary Results:** Your analysis outputs = preliminary data

### What You Need to Add

**For stronger applications:**

1. **Preliminary Results**
   - Run analyses on 100+ TESS targets
   - Find interesting candidates
   - Create compelling visualizations
   - Document in short report

2. **Publications/Presentations**
   - Submit findings to amateur astronomy journals
   - Present at local astronomy club
   - Post to arXiv (if co-authored with researcher)

3. **Partnerships**
   - Contact K-State physics/astronomy faculty
   - Join amateur astronomy organizations
   - Connect with other Beocat researchers

4. **Letters of Support**
   - From Beocat administrators (confirming access)
   - From collaborating researchers
   - From astronomy club (for citizen science projects)

## Sample Application Components

### Budget Justification (Shoemaker Grant)

```
Equipment ($10,000):
- CMOS Camera (QHY600M): $4,500
  Rationale: Improved sensitivity for faint NEO detection
- Filter Wheel + BVRI filters: $2,000
  Rationale: Photometric characterization of NEOs
- Computer upgrade: $1,500
  Rationale: Local preprocessing before Beocat upload
- Software licenses: $500
  Rationale: Astrometry.net, MaxIm DL
- Travel to dark sky site: $1,500
  Rationale: 3 observing runs for NEO follow-up

Total: $10,000

Note: Computational analysis infrastructure (Beocat HPC)
      already available at no cost to grant.
```

### Research Plan Outline

```
1. Significance (Why this matters)
   - NEO detection critical for planetary defense
   - Amateur astronomers provide follow-up observations
   - HPC enables rapid automated analysis

2. Innovation (What's new)
   - First automated HPC pipeline for amateur NEO data
   - Machine learning classification of light curves
   - Real-time alert system for interesting objects

3. Approach (How you'll do it)
   Year 1:
   - Month 1-3: Equipment acquisition and setup
   - Month 4-6: Develop ML classifier on Beocat
   - Month 7-9: Initial observations and pipeline testing
   - Month 10-12: Full survey operations

   Deliverables:
   - 500+ NEO observations
   - Open-source analysis pipeline
   - Submissions to Minor Planet Center
   - 1-2 presentations at astronomy conferences

4. Broader Impacts
   - Code released as open source
   - Engage local astronomy club
   - K-12 outreach presentations
   - Inspire next generation of computational astronomers
```

### Computational Infrastructure Statement

```
"The PI has access to Beocat, Kansas State University's High-Performance
Computing cluster, featuring 8,368 CPU cores across 343 compute nodes and
102 GPUs across 34 GPU-enabled nodes. This infrastructure provides
computational capabilities far exceeding typical amateur astronomy setups,
enabling analysis of thousands of targets in parallel.

Preliminary work using Beocat has demonstrated successful implementation
of automated transit detection pipelines processing TESS exoplanet data
[include your results]. This same computational framework will be adapted
for rapid NEO photometric analysis, enabling same-night processing of
observational data to identify objects requiring immediate follow-up.

The HPC infrastructure is already available and supported, requiring no
grant funds for access or operation, allowing the full budget to be
directed toward observational equipment and operations."
```

## Timeline for Grant Applications

### 3 Months Before Deadline

- [ ] Choose target grant program
- [ ] Contact potential collaborators
- [ ] Run preliminary analyses for results
- [ ] Draft research plan outline

### 2 Months Before

- [ ] Write full proposal draft
- [ ] Create figures and plots from your data
- [ ] Request letters of support
- [ ] Get feedback from mentors

### 1 Month Before

- [ ] Revise based on feedback
- [ ] Finalize budget
- [ ] Prepare required forms
- [ ] Have someone proofread

### 1 Week Before

- [ ] Final review
- [ ] Check all requirements
- [ ] Submit early (don't wait for deadline!)

## Networking for Grants

### Finding Collaborators

**K-State contacts:**
- Physics Department faculty
- Division of Biology (if astrobiology angle)
- Computer Science (for ML collaboration)
- Beocat administrators

**External contacts:**
- American Association of Variable Star Observers (AAVSO)
- American Astronomical Society amateur members
- Regional astronomy clubs
- NASA citizen science project PIs

### Effective Networking

```
Email template:

Subject: Potential collaboration on [grant name] proposal

Dear Dr. [Name],

I am a [your position] with access to Kansas State's Beocat HPC
cluster. I have been conducting exoplanet transit analysis on TESS
data and am interested in applying for [grant name].

I came across your work on [their research] and thought there might
be synergy between my computational capabilities and your scientific
expertise. Would you be interested in discussing a potential
collaboration?

I'd be happy to share my preliminary results and discuss how HPC
analysis could support your research goals.

Best regards,
[Your name]

Attached: [PDF of your best analysis results]
```

## After Getting Funded

### Deliverables

Most grants require:

1. **Progress Reports:** Every 6-12 months
2. **Final Report:** At project end
3. **Publications:** Acknowledge grant in papers
4. **Data Sharing:** Make results publicly available
5. **Outreach:** Public presentations, blog posts

### Maximizing Impact

- Present at conferences (AAS, DPS, etc.)
- Publish in peer-reviewed journals
- Release code on GitHub
- Write for amateur astronomy magazines
- Give talks at astronomy clubs
- Mentor students

### Building for Future Grants

Success with a $10k grant → credibility for $50k grant
Success with $50k grant → credibility for $200k grant

Each grant builds your track record as a researcher.

## Resources

- **Proposal Writing Guide:** https://www.nsf.gov/pubs/
- **Grant Writing Workshop:** Many universities offer free workshops
- **Peer Review:** Find colleagues to review your draft
- **Professional Editing:** Consider for large grants

---

**Remember:** Your Beocat HPC access is a major competitive advantage.
Most amateur astronomers don't have this computational capability!
