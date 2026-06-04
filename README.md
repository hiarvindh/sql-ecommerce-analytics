# sql-ecommerce-analytics
SQL e-commerce analytics project using a relational database, automated data ingestion scripts, and business-focused queries to analyze sales, customers, products, and order behavior.

## Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Analysis Goals](#analysis-goals)
- [SQL Skills Demonstrated](#sql-skills-demonstrated)
- [Dataset](#dataset)

## Overview
This project analyzes a real-world e-commerce dataset using SQL and a structured relational database workflow. It includes database creation, table setup, automated dataset download, data loading, and analytical querying to generate business insights.

## Tech Stack
- SQL
- Python
- Relational database
- Kaggle dataset

## Project Structure
- `CreateDatabase.sql` — creates the database
- `CreateTables.sql` — creates the tables
- `scripts/download_data.py` — downloads the dataset
- `scripts/load_data.py` — loads the dataset into the database
- `README.md` — project overview and setup instructions

## How to Run

### 1. Set up the database
Run the SQL setup files in MySQL Workbench or another MySQL client:

```sql
CreateDatabase.sql
CreateTables.sql
```

### 2. Download the dataset
From the project root, run:
```bash
python3 scripts/download_data.py
```

## Analysis Goals
- Analyze sales and order patterns
- Explore customer purchasing behavior
- Evaluate product and category performance
- Generate business insights from transactional data

## SQL Skills Demonstrated
- Joins
- Aggregations
- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- Filtering and grouping
- Business-oriented analytical queries

## Dataset
This project uses a real-world e-commerce dataset for SQL-based analysis of transactional and customer-related data.