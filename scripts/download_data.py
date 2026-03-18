from pathlib import Path
import argparse
import sys

from kaggle.api.kaggle_api_extended import KaggleApi


DATASET = "olistbr/brazilian-ecommerce"


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def download_dataset(download_dir: Path, unzip: bool = True) -> None:
    """
    Download the full Olist dataset from Kaggle into download_dir.
    """
    ensure_dir(download_dir)

    api = KaggleApi()
    api.authenticate()

    print(f"Downloading dataset '{DATASET}' to {download_dir} ...")
    api.dataset_download_files(
        DATASET,
        path=str(download_dir),
        unzip=unzip,
        quiet=False,
    )
    print("Download complete.")


def download_file(filename: str, download_dir: Path) -> None:
    """
    Download a single file from the Olist dataset.
    Example:
        olist_order_items_dataset.csv
    """
    ensure_dir(download_dir)

    api = KaggleApi()
    api.authenticate()

    print(f"Downloading file '{filename}' from '{DATASET}' to {download_dir} ...")
    api.dataset_download_file(
        DATASET,
        file_name=filename,
        path=str(download_dir),
        force=False,
        quiet=False,
    )
    print("Download complete.")
    print("Note: single-file download is usually saved as a zip by the Kaggle API.")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Download the Olist Brazilian e-commerce dataset from Kaggle."
    )
    parser.add_argument(
        "--dir",
        default="data/raw",
        help="Directory to save downloaded files (default: data/raw)",
    )
    parser.add_argument(
        "--file",
        default=None,
        help="Optional single file to download, e.g. olist_order_items_dataset.csv",
    )
    parser.add_argument(
        "--no-unzip",
        action="store_true",
        help="Do not unzip when downloading the full dataset",
    )

    args = parser.parse_args()
    download_dir = Path(args.dir)

    try:
        if args.file:
            download_file(args.file, download_dir)
        else:
            download_dataset(download_dir, unzip=not args.no_unzip)
        return 0
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        print(
            "Make sure your Kaggle API credentials are configured "
            "(for example via ~/.kaggle/kaggle.json).",
            file=sys.stderr,
        )
        return 1


if __name__ == "__main__":
    raise SystemExit(main())