# 🧹 SQL Project – Data Cleaning for Layoffs Dataset

## 📌 Description
This project focuses on cleaning a real-world dataset related to employee layoffs using SQL. It includes steps like removing duplicates, standardizing columns, handling nulls, and formatting dates.

## 🛠️ Tools Used
- MySQL
- SQL (ROW_NUMBER, CTEs, TRIM, REPLACE, STR_TO_DATE)

## 🧼 Cleaning Steps

1. Create a copy of the original table to work on safely.
2. Remove duplicate rows using `ROW_NUMBER()` and `DELETE`.
3. Standardize company and industry names.
4. Clean country names and remove trailing dots.
5. Convert date column from text to DATE type.
6. Fill null values in `industry` by self-joining.
7. Remove rows where both `total_laid_off` and `percentage_laid_off` are null.
8. Drop unnecessary columns.
9. Use `REPLACE()` to remove symbols like `&` and `#` from text fields.

## 📁 Files
- `sql.clean.sql`: The complete SQL script used to clean the dataset.
