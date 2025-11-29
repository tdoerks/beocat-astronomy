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

    # PHASE 1: 50 Confirmed Exoplanet Host Stars with TESS Data
    # Curated list of well-studied systems with reliable SPOC pipeline data
    tic_ids = [
        # Original 9 (tested and working)
        'TIC 307210830',  # TOI-1130 b,c - Multi-planet system
        'TIC 206544316',  # Pi Mensae c - Confirmed planet
        'TIC 261136679',  # L 98-59 - Multi-planet system
        'TIC 277539431',  # HD 39091 b - Hot Jupiter
        'TIC 388857263',  # HD 221416 b - Sub-Neptune
        'TIC 259377017',  # LHS 3844 b - Rocky planet
        'TIC 234994474',  # HD 21749 b,c - Multi-planet
        'TIC 38846515',   # WASP-18 b - Hot Jupiter
        'TIC 231670397',  # WASP-126 b - Hot Jupiter

        # Additional confirmed exoplanets (10-50)
        'TIC 300163192',  # WASP-52 b - Hot Jupiter
        'TIC 167664935',  # TOI-178 - 6-planet resonant chain
        'TIC 377780944',  # GJ 357 - Multi-planet system
        'TIC 29344935',   # Beta Pictoris b - Young Jupiter
        'TIC 150428135',  # TOI-561 - Dense rocky planet
        'TIC 336732616',  # Qatar-1 b - Hot Jupiter
        'TIC 25155310',   # TOI-270 - Multi-planet system
        'TIC 279741379',  # TOI-1899 b - Sub-Neptune
        'TIC 55652896',   # TOI-1233 b - Rocky planet
        'TIC 92226327',   # TOI-519 b - Mini-Neptune
        'TIC 440887364',  # TOI-1518 b - Hot Jupiter
        'TIC 279737403',  # TOI-421 - Multi-planet
        'TIC 158588995',  # TOI-402 b - Sub-Neptune
        'TIC 229804573',  # TOI-500 b - Sub-Neptune
        'TIC 382445566',  # TOI-532 b - Hot Jupiter
        'TIC 183120439',  # TOI-544 b - Sub-Neptune
        'TIC 219006104',  # TOI-125 b,c - Multi-planet
        'TIC 410214986',  # TOI-1338 b - Circumbinary planet
        'TIC 238855987',  # TOI-1807 b - Ultra-short period
        'TIC 177309964',  # TOI-1136 - Multi-planet system
        'TIC 220479565',  # TOI-216 b,c - Multi-planet
        'TIC 350596914',  # TOI-411 b - Hot Jupiter
        'TIC 278825952',  # TOI-824 b - Sub-Neptune
        'TIC 102090493',  # TOI-836 - Multi-planet
        'TIC 139270665',  # TOI-942 b - Sub-Neptune
        'TIC 201248411',  # TOI-1064 b - Hot Jupiter
        'TIC 257567854',  # TOI-1231 b - Sub-Neptune
        'TIC 268644785',  # TOI-1259 b - Sub-Neptune
        'TIC 285048486',  # TOI-1278 b - Hot Jupiter
        'TIC 178155732',  # TOI-1296 b - Hot Jupiter
        'TIC 382080762',  # TOI-1298 - Multi-planet
        'TIC 293899444',  # TOI-1444 b - Sub-Neptune
        'TIC 55621683',   # TOI-1478 b - Warm Jupiter
        'TIC 219909527',  # TOI-1634 b - Sub-Neptune
        'TIC 293429430',  # TOI-1690 b - Hot Jupiter
        'TIC 350531944',  # TOI-1726 b - Sub-Neptune
        'TIC 228813918',  # TOI-1749 b - Sub-Neptune
        'TIC 279737903',  # TOI-1789 b - Sub-Neptune
        'TIC 349629817',  # TOI-1810 b - Sub-Neptune
        'TIC 372659654',  # TOI-1842 b - Hot Jupiter
        'TIC 460205581',  # TOI-2018 b - Sub-Neptune
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
