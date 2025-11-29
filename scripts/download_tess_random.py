#!/usr/bin/env python3
"""
PHASE 3: Download Random TESS Stars for Discovery
Search random TESS-observed stars for missed exoplanet transits
"""

import lightkurve as lk
import argparse
import os
from tqdm import tqdm
import random

def download_random_tess_stars(num_targets=1000, output_dir='../data/tess_random'):
    """
    Download TESS light curves for random stars

    Parameters:
    -----------
    num_targets : int
        Number of random targets to download
    output_dir : str
        Directory to save downloaded data
    """

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    print(f"Downloading {num_targets} random TESS star light curves...")
    print(f"Output directory: {output_dir}")
    print("Note: Most will have no transits, but you might discover something new!")

    # Strategy: Sample random TIC IDs from TESS Input Catalog
    # TESS observed stars have TIC IDs roughly in range 1-500000000

    # Generate random TIC IDs to try
    print("\nGenerating random TIC IDs to search...")
    random.seed(42)  # Reproducible random selection

    # We'll try more than num_targets since many won't have SPOC data
    attempts = num_targets * 5  # Try 5x to account for failures
    random_tic_ids = random.sample(range(1000000, 500000000), attempts)

    downloaded = 0
    attempted = 0

    print(f"Searching {attempts} random TIC IDs for TESS SPOC data...")
    print("(This may take a while - most stars don't have TESS observations)\n")

    for tic_id in tqdm(random_tic_ids):
        if downloaded >= num_targets:
            break

        attempted += 1

        try:
            # Search for this TIC ID
            search_result = lk.search_lightcurve(
                f'TIC {tic_id}',
                mission='TESS',
                author='SPOC'
            )

            if len(search_result) == 0:
                continue  # No data for this star

            # Download first sector
            lc = search_result[0].download()

            if lc is None:
                continue

            # Save to file
            output_file = os.path.join(output_dir, f"TIC_{tic_id}.fits")
            lc.to_fits(output_file, overwrite=True)

            print(f"  ✓ Downloaded TIC {tic_id}: {len(lc)} data points, Sector {lc.sector}")
            downloaded += 1

        except KeyboardInterrupt:
            print("\n\nDownload interrupted by user")
            break
        except Exception as e:
            # Silent failures - most random TICs won't have data
            continue

    print(f"\nSuccessfully downloaded {downloaded}/{num_targets} random stars")
    print(f"Searched {attempted} TIC IDs to find {downloaded} with TESS data")
    print(f"Hit rate: {100*downloaded/attempted:.1f}%")

    return downloaded

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download random TESS star light curves')
    parser.add_argument('-n', '--num-targets', type=int, default=1000,
                        help='Number of random stars to download (default: 1000)')
    parser.add_argument('-o', '--output-dir', type=str, default='../data/tess_random',
                        help='Output directory (default: ../data/tess_random)')

    args = parser.parse_args()

    download_random_tess_stars(args.num_targets, args.output_dir)
