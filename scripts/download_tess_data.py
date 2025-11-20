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

    # Sample of interesting TIC IDs (known planets and candidates)
    tic_ids = [
        'TIC 25155310',  # TOI-270
        'TIC 219006104', # TOI-125
        'TIC 410214986', # TOI-1338
        'TIC 307210830', # TOI-2076
        'TIC 238855987', # TOI-1807
        'TIC 279741379', # TOI-1899
        'TIC 177309964', # TOI-1136
        'TIC 55652896',  # TOI-1233
        'TIC 92226327',  # TOI-519
        'TIC 440887364', # TOI-1518
    ]

    # Limit to requested number
    tic_ids = tic_ids[:num_targets]

    downloaded = 0
    for tic_id in tqdm(tic_ids):
        try:
            # Search for TESS data
            search_result = lk.search_lightcurve(tic_id, mission='TESS')

            if len(search_result) == 0:
                print(f"  No data found for {tic_id}")
                continue

            # Download all available sectors
            lc_collection = search_result.download_all()

            # Save to file
            output_file = os.path.join(output_dir, f"{tic_id.replace(' ', '_')}.fits")

            # Stitch sectors together if multiple
            if len(lc_collection) > 1:
                lc = lc_collection.stitch()
            else:
                lc = lc_collection[0]

            lc.to_fits(output_file, overwrite=True)

            print(f"  Downloaded {tic_id}: {len(lc)} data points")
            downloaded += 1

        except Exception as e:
            print(f"  Error downloading {tic_id}: {e}")
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
