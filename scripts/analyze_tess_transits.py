#!/usr/bin/env python3
"""
Analyze TESS light curves for exoplanet transits
This script performs basic transit detection and analysis
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend for HPC
import matplotlib.pyplot as plt
import lightkurve as lk
import os
import argparse
from glob import glob

def analyze_lightcurve(fits_file, output_dir='../results'):
    """
    Analyze a single TESS light curve for transits

    Parameters:
    -----------
    fits_file : str
        Path to FITS file containing light curve
    output_dir : str
        Directory to save results
    """

    # Load light curve using lightkurve's TESS-specific reader
    lc = lk.read(fits_file)

    # Get target name from filename
    target_name = os.path.basename(fits_file).replace('.fits', '')

    print(f"\nAnalyzing {target_name}...")
    print(f"  Data points: {len(lc)}")
    print(f"  Time range: {lc.time.min().value:.2f} to {lc.time.max().value:.2f} days")

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Normalize and clean the light curve
    # Remove NaNs and convert to SAP flux (removes unit issues)
    lc = lc.remove_nans()

    # Convert flux to simple array to avoid unit arithmetic issues
    lc = lc.normalize()
    lc.flux = lc.flux.value  # Strip units

    lc = lc.remove_outliers(sigma=5)

    # Flatten to remove stellar variability
    flat_lc = lc.flatten(window_length=401)

    # Run BLS (Box Least Squares) periodogram to find transits
    print("  Running transit search...")
    periodogram = flat_lc.to_periodogram(method='bls', period=np.arange(0.5, 20, 0.001))

    # Get best period
    best_period = periodogram.period_at_max_power
    best_power = periodogram.max_power

    print(f"  Best period found: {best_period:.4f} days")
    print(f"  Transit power: {best_power:.4f}")

    # Create plots
    fig, axes = plt.subplots(3, 1, figsize=(12, 10))

    # Plot 1: Raw light curve
    lc.plot(ax=axes[0], label='Raw')
    axes[0].set_title(f'{target_name} - Raw Light Curve')
    axes[0].legend()

    # Plot 2: Flattened light curve
    flat_lc.plot(ax=axes[1], label='Flattened')
    axes[1].set_title('Flattened Light Curve')
    axes[1].legend()

    # Plot 3: Periodogram
    periodogram.plot(ax=axes[2])
    axes[2].axvline(best_period.value, color='r', linestyle='--',
                    label=f'Best Period: {best_period:.4f} days')
    axes[2].set_title('BLS Periodogram')
    axes[2].legend()

    plt.tight_layout()

    # Save plot
    plot_file = os.path.join(output_dir, f'{target_name}_analysis.png')
    plt.savefig(plot_file, dpi=150)
    plt.close()

    print(f"  Saved plot to {plot_file}")

    # Create phase-folded plot
    fig, ax = plt.subplots(1, 1, figsize=(10, 6))
    folded_lc = flat_lc.fold(period=best_period)
    folded_lc.scatter(ax=ax, s=1, alpha=0.5)
    ax.set_title(f'{target_name} - Phase-Folded at {best_period:.4f} days')

    folded_file = os.path.join(output_dir, f'{target_name}_folded.png')
    plt.savefig(folded_file, dpi=150)
    plt.close()

    print(f"  Saved phase-folded plot to {folded_file}")

    return {
        'target': target_name,
        'n_points': len(lc),
        'period': float(best_period.value),
        'power': float(best_power.value)
    }

def analyze_all_targets(data_dir='../data/tess', output_dir='../results'):
    """
    Analyze all TESS light curves in directory
    """

    # Find all FITS files
    fits_files = glob(os.path.join(data_dir, '*.fits'))

    if len(fits_files) == 0:
        print(f"No FITS files found in {data_dir}")
        return

    print(f"Found {len(fits_files)} light curves to analyze")

    results = []
    for fits_file in fits_files:
        try:
            result = analyze_lightcurve(fits_file, output_dir)
            results.append(result)
        except Exception as e:
            print(f"Error analyzing {fits_file}: {e}")
            continue

    # Save summary
    summary_file = os.path.join(output_dir, 'analysis_summary.txt')
    with open(summary_file, 'w') as f:
        f.write("TESS Transit Analysis Summary\n")
        f.write("=" * 60 + "\n\n")
        for r in results:
            f.write(f"Target: {r['target']}\n")
            f.write(f"  Data points: {r['n_points']}\n")
            f.write(f"  Best period: {r['period']:.4f} days\n")
            f.write(f"  Transit power: {r['power']:.4f}\n\n")

    print(f"\nAnalysis complete! Summary saved to {summary_file}")
    print(f"Analyzed {len(results)} targets successfully")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Analyze TESS light curves for transits')
    parser.add_argument('-d', '--data-dir', type=str, default='../data/tess',
                        help='Directory containing TESS FITS files')
    parser.add_argument('-o', '--output-dir', type=str, default='../results',
                        help='Output directory for results')

    args = parser.parse_args()

    analyze_all_targets(args.data_dir, args.output_dir)
