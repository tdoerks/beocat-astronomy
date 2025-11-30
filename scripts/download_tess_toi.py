#!/usr/bin/env python3
"""
PHASE 2: Download TESS TOI (TESS Objects of Interest) Candidates
These are unconfirmed exoplanet candidates flagged by TESS that need follow-up
"""

import lightkurve as lk
import argparse
import os
from tqdm import tqdm

def download_toi_candidates(num_targets=200, output_dir='../data/tess_toi'):
    """
    Download TESS light curves for TOI candidates

    Parameters:
    -----------
    num_targets : int
        Number of TOI targets to download
    output_dir : str
        Directory to save downloaded data
    """

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    print(f"Downloading {num_targets} TOI candidate light curves...")
    print(f"Output directory: {output_dir}")
    print("Note: These are UNCONFIRMED candidates - your analysis helps validate them!")

    # Search for TOI candidates using lightkurve
    # We'll search for targets with "TOI" in their name
    print("\nSearching TESS archive for TOI candidates...")

    # Get TOI catalog
    try:
        # Search for TESS observations with TOI designation
        search_results = lk.search_lightcurve(
            'TOI',
            mission='TESS',
            author='SPOC'
        )

        if len(search_results) == 0:
            print("No TOI candidates found in initial search")
            print("Falling back to direct TOI number search...")

            # Fallback: Try specific TOI numbers
            # For full catalog: range(1, 7500) covers all known TOIs
            toi_numbers = list(range(1, 7500))  # TOI-1 through TOI-7499
            downloaded = 0

            for toi_num in tqdm(toi_numbers[:num_targets]):
                try:
                    toi_name = f'TOI-{toi_num}'
                    search = lk.search_lightcurve(toi_name, mission='TESS', author='SPOC')

                    if len(search) == 0:
                        continue

                    # Download first sector
                    lc = search[0].download()

                    if lc is None:
                        continue

                    # Save to file
                    # Get TIC ID from light curve if available
                    tic_id = getattr(lc, 'targetid', toi_name.replace('-', '_'))
                    output_file = os.path.join(output_dir, f"TOI_{toi_num}_TIC_{tic_id}.fits")
                    lc.to_fits(output_file, overwrite=True)

                    print(f"  ✓ Downloaded {toi_name} (TIC {tic_id}): {len(lc)} data points, Sector {lc.sector}")
                    downloaded += 1

                except Exception as e:
                    continue

            print(f"\nSuccessfully downloaded {downloaded}/{num_targets} TOI candidates")
            return downloaded

        # If we found results, process them
        print(f"Found {len(search_results)} TOI observations")

        # Get unique targets (many TOIs have multiple sectors)
        unique_targets = {}
        for result in search_results:
            target_name = result.target_name
            if target_name not in unique_targets:
                unique_targets[target_name] = result

        print(f"Found {len(unique_targets)} unique TOI targets")

        # Download up to num_targets
        targets_to_download = list(unique_targets.items())[:num_targets]
        downloaded = 0

        for target_name, result in tqdm(targets_to_download):
            try:
                lc = result.download()

                if lc is None:
                    print(f"  Download failed for {target_name}")
                    continue

                # Save to file
                safe_name = target_name.replace(' ', '_').replace('/', '_')
                output_file = os.path.join(output_dir, f"{safe_name}.fits")
                lc.to_fits(output_file, overwrite=True)

                print(f"  ✓ Downloaded {target_name}: {len(lc)} data points, Sector {lc.sector}")
                downloaded += 1

            except Exception as e:
                print(f"  ✗ Error downloading {target_name}: {str(e)[:100]}")
                continue

        print(f"\nSuccessfully downloaded {downloaded}/{num_targets} TOI candidates")
        return downloaded

    except Exception as e:
        print(f"Error in TOI search: {e}")
        print("This may be due to MAST archive issues. Try again later.")
        return 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download TOI candidate light curves')
    parser.add_argument('-n', '--num-targets', type=int, default=200,
                        help='Number of TOI candidates to download (default: 200)')
    parser.add_argument('-o', '--output-dir', type=str, default='../data/tess_toi',
                        help='Output directory (default: ../data/tess_toi)')

    args = parser.parse_args()

    download_toi_candidates(args.num_targets, args.output_dir)
