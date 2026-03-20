import os
from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv


BASE_DIR = Path(__file__).resolve().parent.parent
ENV_PATH = BASE_DIR / ".env"
load_dotenv(dotenv_path=ENV_PATH)

DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME", "ecommerce_analytics_olist")

DATA_DIR = BASE_DIR / "data" / "raw"

TABLE_FILES = [
    ("olist_customers_dataset", "olist_customers_dataset.csv"),
    ("olist_geolocation_dataset", "olist_geolocation_dataset.csv"),
    ("product_category_name_translation", "product_category_name_translation.csv"),
    ("olist_products_dataset", "olist_products_dataset.csv"),
    ("olist_sellers_dataset", "olist_sellers_dataset.csv"),
    ("olist_orders_dataset", "olist_orders_dataset.csv"),
    ("olist_order_items_dataset", "olist_order_items_dataset.csv"),
    ("olist_order_payments_dataset", "olist_order_payments_dataset.csv"),
    ("olist_order_reviews_dataset", "olist_order_reviews_dataset.csv"),
]

DATETIME_COLUMNS = {
    "olist_order_items_dataset": ["shipping_limit_date"],
    "olist_order_reviews_dataset": ["review_creation_date", "review_answer_timestamp"],
    "olist_orders_dataset": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
}


def get_engine():
    if not DB_PASSWORD:
        raise ValueError(
            f"DB_PASSWORD is missing. Check that your .env file exists at: {ENV_PATH}"
        )

    encoded_password = quote_plus(DB_PASSWORD)

    return create_engine(
        f"mysql+pymysql://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}",
        pool_pre_ping=True,
    )


def clean_dataframe(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    df = df.copy()

    # Convert blank strings to NULL
    df = df.replace(r"^\s*$", None, regex=True)

    # Parse datetime columns
    for col in DATETIME_COLUMNS.get(table_name, []):
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")

    # Preserve zip code prefixes as strings with leading zeros
    zip_prefix_cols = [
        "customer_zip_code_prefix",
        "seller_zip_code_prefix",
        "geolocation_zip_code_prefix",
    ]
    for col in zip_prefix_cols:
        if col in df.columns:
            df[col] = (
                df[col]
                .astype("string")
                .str.replace(r"\.0$", "", regex=True)
                .str.zfill(5)
            )

    # Normalize integer-like nullable columns
    int_like_cols = [
        "order_item_id",
        "payment_sequential",
        "payment_installments",
        "review_score",
        "product_name_lenght",
        "product_description_lenght",
        "product_photos_qty",
        "product_weight_g",
        "product_length_cm",
        "product_height_cm",
        "product_width_cm",
    ]
    for col in int_like_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    # Normalize decimal-like columns
    decimal_cols = ["price", "freight_value", "payment_value", "geolocation_lat", "geolocation_lng"]
    for col in decimal_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    return df


def truncate_table(engine, table_name: str) -> None:
    with engine.begin() as conn:
        conn.execute(text(f"DELETE FROM {table_name}"))


def load_table(engine, table_name: str, csv_filename: str) -> None:
    csv_path = DATA_DIR / csv_filename

    if not csv_path.exists():
        raise FileNotFoundError(f"Missing file: {csv_path}")

    print(f"\nLoading {table_name} from {csv_filename}...")
    df = pd.read_csv(csv_path)
    df = clean_dataframe(df, table_name)

    truncate_table(engine, table_name)

    df.to_sql (
        name=table_name,
        con=engine,
        if_exists="append",
        index=False,
        chunksize=100,
        method=None,
    )

    print(f"Loaded {len(df):,} rows into {table_name}.")


def main():
    engine = get_engine()

    print("Starting data load...")

    for table_name, csv_filename in TABLE_FILES:
        load_table(engine, table_name, csv_filename)

    print("\nAll tables loaded successfully.")


if __name__ == "__main__":
    main()