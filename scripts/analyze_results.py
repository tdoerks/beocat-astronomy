#!/usr/bin/env python3
"""
Analyze TESS transit detection results and identify strongest candidates.

Reads analysis_summary.txt files from Phase 3 results and compiles:
- Top candidates ranked by transit power
- Statistics across all detections
- CSV file ready for publication/Zenodo

Usage:
    python analyze_results.py
"""

import os
import re
import pandas as pd
import numpy as np
from pathlib import Path

def parse_analysis_summary(summary_file):
    """
    Parse analysis_summary.txt file and extract transit parameters.

    Returns:
        DataFrame with columns: TIC_ID, data_points, period_days, transit_power
    """
    results = []

    with open(summary_file, 'r') as f:
        lines = f.readlines()

    current_target = None
    current_data = {}

    for line in lines:
        line = line.strip()

        # Look for target line
        if line.startswith('Target: TIC_'):
            if current_target and current_data:
                results.append(current_data)

            current_target = line.split('Target: ')[1]
            current_data = {'TIC_ID': current_target}

        # Extract data points
        elif 'Data points:' in line:
            match = re.search(r'Data points:\s*(\d+)', line)
            if match:
                current_data['data_points'] = int(match.group(1))

        # Extract period
        elif 'Best period:' in line:
            match = re.search(r'Best period:\s*([\d.]+)', line)
            if match:
                current_data['period_days'] = float(match.group(1))

        # Extract transit power
        elif 'Transit power:' in line:
            match = re.search(r'Transit power:\s*([\d.]+)', line)
            if match:
                current_data['transit_power'] = float(match.group(1))

    # Add last target
    if current_target and current_data:
        results.append(current_data)

    df = pd.DataFrame(results)
    return df


def analyze_phase3_results(base_dir='/homes/tylerdoe/beocat-astronomy/results'):
    """
    Analyze all Phase 3 results and compile statistics.
    """

    print("=" * 70)
    print("TESS Random Star Analysis - Results Summary")
    print("=" * 70)
    print()

    # Phase 3 original (529 stars)
    phase3_file = os.path.join(base_dir, 'phase3_random', 'analysis_summary.txt')
    phase3_mega_file = os.path.join(base_dir, 'phase3_mega_analysis', 'analysis_summary.txt')

    all_results = []

    # Parse Phase 3 (529 stars)
    if os.path.exists(phase3_file):
        print("Loading Phase 3 results (529 random stars)...")
        df_phase3 = parse_analysis_summary(phase3_file)
        df_phase3['phase'] = 'Phase3_529'
        all_results.append(df_phase3)
        print(f"  ✓ Loaded {len(df_phase3)} targets")
        print(f"  Transit power range: {df_phase3['transit_power'].min():.1f} to {df_phase3['transit_power'].max():.1f}")
        print()

    # Parse Phase 3 MEGA (4,673 stars)
    if os.path.exists(phase3_mega_file):
        print("Loading Phase 3 MEGA results (4,673 random stars)...")
        df_mega = parse_analysis_summary(phase3_mega_file)
        df_mega['phase'] = 'Phase3_MEGA_4673'
        all_results.append(df_mega)
        print(f"  ✓ Loaded {len(df_mega)} targets")
        print(f"  Transit power range: {df_mega['transit_power'].min():.1f} to {df_mega['transit_power'].max():.1f}")
        print()

    # Combine all results
    if not all_results:
        print("ERROR: No results found!")
        return None

    df_all = pd.concat(all_results, ignore_index=True)

    print("=" * 70)
    print(f"COMBINED RESULTS: {len(df_all)} total random stars analyzed")
    print("=" * 70)
    print()

    # Overall statistics
    print("OVERALL STATISTICS:")
    print(f"  Total targets: {len(df_all)}")
    print(f"  Mean transit power: {df_all['transit_power'].mean():.2f}")
    print(f"  Median transit power: {df_all['transit_power'].median():.2f}")
    print(f"  Max transit power: {df_all['transit_power'].max():.2f}")
    print()

    # Period statistics
    print("PERIOD DISTRIBUTION:")
    print(f"  Min period: {df_all['period_days'].min():.3f} days")
    print(f"  Max period: {df_all['period_days'].max():.3f} days")
    print(f"  Median period: {df_all['period_days'].median():.3f} days")
    print()

    # Categorize by transit power
    strong = df_all[df_all['transit_power'] > 1000]
    moderate = df_all[(df_all['transit_power'] > 100) & (df_all['transit_power'] <= 1000)]
    weak = df_all[df_all['transit_power'] <= 100]

    print("DETECTIONS BY STRENGTH:")
    print(f"  Strong (power > 1,000): {len(strong)} candidates ({len(strong)/len(df_all)*100:.1f}%)")
    print(f"  Moderate (100-1,000): {len(moderate)} candidates ({len(moderate)/len(df_all)*100:.1f}%)")
    print(f"  Weak (< 100): {len(weak)} candidates ({len(weak)/len(df_all)*100:.1f}%)")
    print()

    # Top 20 candidates
    top20 = df_all.nlargest(20, 'transit_power')

    print("=" * 70)
    print("TOP 20 STRONGEST CANDIDATES")
    print("=" * 70)
    print()
    print(f"{'Rank':<5} {'TIC ID':<20} {'Period':<12} {'Power':<15} {'Phase':<20}")
    print("-" * 70)
    for idx, (i, row) in enumerate(top20.iterrows(), 1):
        print(f"{idx:<5} {row['TIC_ID']:<20} {row['period_days']:>8.4f} d  {row['transit_power']:>12,.1f}  {row['phase']:<20}")
    print()

    # Candidates for ExoFOP submission (power > 10,000)
    exofop_candidates = df_all[df_all['transit_power'] > 10000]

    print("=" * 70)
    print(f"CANDIDATES FOR ExoFOP SUBMISSION (power > 10,000): {len(exofop_candidates)}")
    print("=" * 70)
    print()

    if len(exofop_candidates) > 0:
        print(f"{'TIC ID':<20} {'Period':<12} {'Power':<15} {'Phase':<20}")
        print("-" * 70)
        for i, row in exofop_candidates.iterrows():
            print(f"{row['TIC_ID']:<20} {row['period_days']:>8.4f} d  {row['transit_power']:>12,.1f}  {row['phase']:<20}")
        print()
        print("** These candidates should be visually inspected before ExoFOP submission **")
        print("** Check plots to confirm transit shape and rule out false positives **")
    else:
        print("No candidates with power > 10,000 found.")
        print("Consider lowering threshold or visually inspecting top 20 candidates.")
    print()

    # Save compiled CSV
    output_file = os.path.join(base_dir, 'phase3_all_random_stars_compiled.csv')
    df_all_sorted = df_all.sort_values('transit_power', ascending=False)
    df_all_sorted.to_csv(output_file, index=False)

    print("=" * 70)
    print(f"RESULTS SAVED")
    print("=" * 70)
    print(f"  CSV file: {output_file}")
    print(f"  Total entries: {len(df_all_sorted)}")
    print()

    print("NEXT STEPS:")
    print("  1. Visually inspect top 20 candidates (check plots)")
    print("  2. Cross-check TIC IDs with TOI catalog (avoid duplicates)")
    print("  3. Select 5-10 strongest for ExoFOP submission")
    print("  4. Upload CSV + top plots to Zenodo")
    print()

    return df_all_sorted


if __name__ == '__main__':
    df = analyze_phase3_results()

    if df is not None:
        print("Analysis complete! ✓")
        print()
        print("To view results:")
        print("  cat ~/beocat-astronomy/results/phase3_all_random_stars_compiled.csv | head -30")
