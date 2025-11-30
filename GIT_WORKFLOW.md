# Git Workflow for TESS Exoplanet Analysis Pipeline

## Branch Structure

```
main (development/testing)
  ├── Feature development
  ├── Bug fixes
  └── Experimental code

stable (proven working code)
  ├── Tested features only
  ├── Merge from main when validated
  └── Tagged versions (v1.0, v1.1, etc.)
```

## Branching Strategy

### `main` Branch
- **Purpose:** Development and testing
- **Use for:**
  - Adding new features
  - Fixing bugs
  - Experimental analysis methods
  - Testing new parameters
- **State:** May have untested code
- **Push frequency:** Often (after each logical change)

### `stable` Branch
- **Purpose:** Production-ready, proven code
- **Use for:**
  - Running large-scale analyses
  - Grant application demonstrations
  - Sharing with collaborators
- **State:** All code tested and validated
- **Update frequency:** Only after successful validation

## Version Tagging

Tags mark significant milestones and allow easy rollback.

### Tag Naming Convention
```
v<major>.<minor>-<description>

Examples:
v1.0-initial-working
v1.1-phase1-phase2-validated
v1.2-all-phases-complete
v2.0-ml-classification-added
```

### When to Create Tags

**Minor versions (v1.x):**
- New features added and tested
- Bug fixes that improve existing functionality
- Additional analysis capabilities

**Major versions (v2.x, v3.x):**
- Significant architecture changes
- New analysis methods (e.g., ML classification)
- Breaking changes to API/workflow

## Current Tags

### v1.0-initial-working
**Date:** November 29, 2025
**Status:** ✅ Validated

**Features:**
- 3-phase download system (confirmed, TOI, random)
- BLS periodogram transit detection
- Fixed astropy unit compatibility issues
- SLURM job scripts for HPC execution

**Validation:**
- 9 confirmed exoplanets successfully analyzed
- Detected periods match known values
- Pi Mensae: 0.644d (transit power: 288,860)
- WASP-18: 2.849d (transit power: 2,310)
- All 18 plots generated correctly

**Known limitations:**
- Only tested on small dataset (9 targets)
- Phase 2 and Phase 3 not yet validated at scale

## Workflow Examples

### Adding a New Feature

```bash
# Work on main branch
git checkout main

# Make changes, test locally
# ... edit files ...

# Commit and push to main
git add .
git commit -m "Add new feature: X"
git push origin main

# Test on Beocat
# ... run SLURM jobs ...

# If successful, merge to stable
git checkout stable
git merge main
git tag -a v1.1-feature-x -m "Added feature X, validated on Y samples"
git push origin stable
git push origin v1.1-feature-x

# Return to main for continued development
git checkout main
```

### Rolling Back to Stable Version

```bash
# If main branch has broken code, rollback to stable
git checkout stable

# Or rollback to specific tag
git checkout v1.0-initial-working

# To return to latest development
git checkout main
```

### Checking Out Specific Version for Production Run

```bash
# Use stable for important analysis
git checkout stable

# Or use specific validated version
git checkout v1.1-phase1-phase2-validated

# Run your analysis
sbatch analyze_phase1_confirmed.slurm

# Return to development
git checkout main
```

## Merge Strategy

### When to Merge `main` → `stable`

Merge when ALL of these conditions are met:

1. ✅ **Feature is complete** - No half-implemented functionality
2. ✅ **Tests pass** - Analysis runs successfully on sample data
3. ✅ **Results validated** - Detected periods match known values (for confirmed exoplanets)
4. ✅ **Documentation updated** - README/SESSION_STATUS reflects new features
5. ✅ **No known bugs** - No critical errors in logs

### Merge Process

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Switch to stable
git checkout stable
git pull origin stable

# Merge main into stable
git merge main

# If conflicts, resolve them
# ... fix conflicts ...
git add .
git commit -m "Merge main: added feature X"

# Tag the new stable version
git tag -a v1.1-description -m "Detailed tag message"

# Push to GitHub
git push origin stable
git push origin v1.1-description

# Return to main
git checkout main
```

## Development Milestones

### Planned Versions

**v1.1-phase1-phase2-validated** (Next)
- ⏳ Phase 1: 33 confirmed exoplanets analyzed
- ⏳ Phase 2: 196 TOI candidates analyzed
- Validation: Check detected periods against known values
- Expected: ~229 successful transit detections

**v1.2-all-phases-complete**
- ⏳ Phase 3: 1,000 random stars analyzed
- Potential new discoveries flagged
- Complete 3-phase pipeline validated

**v2.0-discovery-mode** (Future)
- Automated discovery classification
- Machine learning transit validation
- Statistical analysis of detection rates
- Publication-ready visualizations

## Best Practices

### DO:
- ✅ Commit often on main with clear messages
- ✅ Test thoroughly before merging to stable
- ✅ Tag stable versions for easy rollback
- ✅ Document what each version includes
- ✅ Keep stable branch clean (no experimental code)

### DON'T:
- ❌ Push untested code to stable
- ❌ Merge main → stable without validation
- ❌ Delete tags (they're your safety net)
- ❌ Force push to stable (use merge instead)
- ❌ Work directly on stable (always use main)

## Troubleshooting

### "I broke something on main, need to rollback"
```bash
# Option 1: Revert to last commit
git revert HEAD

# Option 2: Reset to previous commit (loses changes)
git reset --hard HEAD~1

# Option 3: Start fresh from stable
git checkout stable
git checkout -b main-new
# ... then reset main to this state
```

### "Stable branch is behind main, how do I update?"
```bash
git checkout stable
git merge main
git push origin stable
```

### "I accidentally committed to stable instead of main"
```bash
# Don't panic! Create a new branch from stable
git checkout stable
git checkout -b temp-fixes

# Reset stable to last known good state
git checkout stable
git reset --hard v1.0-initial-working

# Merge your fixes from temp branch to main
git checkout main
git merge temp-fixes
```

## Quick Reference

```bash
# View all branches
git branch -a

# View all tags
git tag -l

# View tag details
git show v1.0-initial-working

# Compare branches
git diff main..stable

# See commit history
git log --oneline --graph --all

# Check which branch you're on
git branch
```

---

**Remember:**
- `main` = playground (break things, experiment)
- `stable` = production (proven, reliable)
- Tags = time machine (rollback anytime)

**Golden Rule:** If you're about to run analysis for a grant application or publication, ALWAYS use `stable` or a tagged version, never `main`!
