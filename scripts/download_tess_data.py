#!/usr/bin/env python3
"""
Download TESS light curves for analysis
This script downloads a sample of TESS targets for exoplanet transit analysis
"""

import lightkurve as lk
import argparse
import os
from tqdm import tqdm

def download_tess_sample(num_targets=10, output_dir='../data/tess'):
    """
    Download TESS light curves for a sample of targets

    Parameters:
    -----------
    num_targets : int
        Number of targets to download
    output_dir : str
        Directory to save downloaded data
    """

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    print(f"Downloading {num_targets} TESS light curves...")
    print(f"Output directory: {output_dir}")

    # Sample of interesting TIC IDs (known planets with confirmed TESS data)
    # Using well-studied exoplanet systems with reliable SPOC pipeline data
    tic_ids = [
        'TIC 307210830',  # TOI-1130 b,c - Multi-planet system
        'TIC 206544316',  # Pi Mensae c - Confirmed planet
        'TIC 261136679',  # L 98-59 - Multi-planet system
        'TIC 277539431',  # HD 39091 b - Hot Jupiter
        'TIC 388857263',  # HD 221416 b - Sub-Neptune
        'TIC 259377017',  # LHS 3844 b - Rocky planet
        'TIC 234994474',  # HD 21749 b,c - Multi-planet
        'TIC 38846515',   # WASP-18 b - Hot Jupiter
        'TIC 231670397',  # WASP-126 b - Hot Jupiter
        'TIC 300163192',  # WASP-52 b - Hot Jupiter
        'TIC 167664935',  # TOI-178 - Multi-planet system
        'TIC 377780944',  # GJ 357 - Multi-planet system
        'TIC 29344935',   # Beta Pictoris b - Young Jupiter
        'TIC 150428135',  # TOI-561 - Dense rocky planet
        'TIC 336732616',  # Qatar-1 b - Hot Jupiter
    ]

    # Limit to requested number
    tic_ids = tic_ids[:num_targets]

    downloaded = 0
    for tic_id in tqdm(tic_ids):
        try:
            # Search for TESS SPOC (Science Processing Operations Center) data only
            # This ensures we get high-quality, properly processed light curves
            search_result = lk.search_lightcurve(
                tic_id,
                mission='TESS',
                author='SPOC'  # Use only official TESS pipeline products
            )

            if len(search_result) == 0:
                print(f"  No SPOC data found for {tic_id}")
                continue

            # Download first available sector only (faster, less data)
            # Change to .download_all() if you want all sectors
            lc = search_result[0].download()

            if lc is None:
                print(f"  Download failed for {tic_id}")
                continue

            # Save to file
            output_file = os.path.join(output_dir, f"{tic_id.replace(' ', '_')}.fits")
            lc.to_fits(output_file, overwrite=True)

            print(f"  ✓ Downloaded {tic_id}: {len(lc)} data points, Sector {lc.sector}")
            downloaded += 1

        except Exception as e:
            print(f"  ✗ Error downloading {tic_id}: {str(e)[:100]}")
            continue

    print(f"\nSuccessfully downloaded {downloaded}/{len(tic_ids)} targets")
    return downloaded

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download TESS light curves')
    parser.add_argument('-n', '--num-targets', type=int, default=10,
                        help='Number of targets to download (default: 10)')
    parser.add_argument('-o', '--output-dir', type=str, default='../data/tess',
                        help='Output directory (default: ../data/tess)')

    args = parser.parse_args()

    download_tess_sample(args.num_targets, args.output_dir)
