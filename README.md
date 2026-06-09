# data-cleaning-layoffs-project

## Overview
This project focuses on cleaning and preparing a real-world layoffs dataset using SQL. The goal was to transform raw data into a structured and analysis-ready format.

This project was inspired by Alex The Analyst as part of my learning journey, with additional notes and understanding added throughout.

---

## Objectives
- Remove duplicate records
- Standardize inconsistent data values
- Handle missing (NULL/blank) values
- Convert data types for analysis
- Remove unnecessary columns and rows

---

## Tools Used
- MySQL
- SQL (Window Functions, CTEs, Joins, String Functions, Date Functions)

---

## Dataset
The dataset contains information about company layoffs including:
- Company name
- Location
- Industry
- Total employees laid off
- Percentage laid off
- Date
- Funding raised
- Company stage

---

## Steps Performed

### 1. Data Exploration
- Inspected raw dataset for inconsistencies and missing values

### 2. Creating a Staging Table
- Created a duplicate table to preserve original data integrity

### 3. Removing Duplicates
- Used `ROW_NUMBER()` with partitioning to identify duplicates
- Deleted duplicate rows safely

### 4. Standardizing Data
- Removed extra whitespace using `TRIM()`
- Standardized industry values (e.g., Crypto variations)
- Cleaned country names (removed trailing periods)
- Converted date strings into proper DATE format

### 5. Handling Missing Values
- Converted blank values to NULL
- Filled missing industry values using matching company records via JOIN

### 6. Removing Unnecessary Data
- Deleted rows where both layoff fields were NULL
- Dropped helper column (`row_num`)

---

## Outcomes / Results

After cleaning the dataset:

- Duplicate rows were successfully identified and removed using window functions
- Inconsistent text values were standardized across multiple columns
- Missing industry values were significantly reduced using data inference via joins
- Date values were converted from text to proper DATE format for analysis
- Rows with no meaningful layoff data were removed
- Final dataset became cleaner, structured, and ready for analysis

### Final Impact:
- Improved data consistency and reliability
- Reduced data redundancy
- Enabled accurate time-series and company-level analysis
- Transformed raw dataset into an analysis-ready format

---

## Key SQL Concepts Used
- Window Functions (`ROW_NUMBER()`)
- CTEs (Common Table Expressions)
- Joins
- `UPDATE`, `DELETE`, `ALTER TABLE`
- String Functions (`TRIM`, `LIKE`)
- Date Conversion (`STR_TO_DATE`)

---

## Key Learnings
- Importance of staging tables in data cleaning workflows
- Real-world datasets are messy and require multiple cleaning steps
- SQL can be used as a full data preprocessing tool
- How to handle duplicates, missing values, and inconsistent formatting

---

## Acknowledgements
This project was completed as part of my SQL learning journey, following Alex The Analyst, with additional interpretation and documentation added.
