/*
DATA CLEANING PROJECT - LAYOFFS DATASET
June 2026

Goals:
1. Remove duplicate records
2. Standardize data
3. Handle null and blank values
4. Remove unnecessary columns

Skills Demonstrated:
* Window Functions
* CTEs
* Joins
* UPDATE Statements
* DELETE Statements
* ALTER TABLE
* Data Type Conversion
  =====================================================
  */

-- ==========================================
-- Initial Data Exploration
-- ==========================================

SELECT *
FROM layoffs;

-- ==========================================
-- Create Staging Table
-- ==========================================

-- Create a copy so the original dataset remains untouched

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- ==========================================
-- Step 1: Remove Duplicates
-- ==========================================

-- First attempt using a CTE
-- Learning Note:
-- MySQL does not allow deleting directly from this CTE approach.

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
stage,
country,
funds_raised_millions,
`date`
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Create a new staging table with row numbers

CREATE TABLE layoffs_staging2 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
stage,
country,
funds_raised_millions,
`date`
) AS row_num
FROM layoffs_staging;

-- Review duplicates

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Remove duplicates

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Verify duplicates are gone

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- ==========================================
-- Step 2: Standardize Data
-- ==========================================

-- Remove leading/trailing spaces from company names

SELECT company,
TRIM(company) AS trimmed_company
FROM layoffs_staging2;

-- Learning Note:
-- TRIM() removes whitespace from both ends of a string.

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Review industry values

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Learning Note:
-- ORDER BY 1 means sort using the first column in the SELECT list.

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Review locations

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Review countries

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Remove trailing periods

SELECT DISTINCT country,
TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert text dates into DATE format

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- Learning Note:
-- %m = month
-- %d = day
-- %Y = four-digit year

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- ==========================================
-- Step 3: Handle Null and Blank Values
-- ==========================================

-- Convert blank industries to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Fill missing industries using matching company names

SELECT t1.company,
t1.industry,
t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Verify results

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- ==========================================
-- Remove Rows With No Useful Layoff Data
-- ==========================================

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- ==========================================
-- Step 4: Remove Unnecessary Columns
-- ==========================================

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- ==========================================
-- Final Cleaned Dataset
-- ==========================================

SELECT *
FROM layoffs_staging2;
