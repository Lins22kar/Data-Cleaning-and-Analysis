-- Project 1

SELECT *
FROM layoffs;

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

INSERT layoff_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) as rom_num
FROM layoff_staging
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) as rom_num
FROM layoff_staging

)
SELECT *
FROM duplicate_cte
WHERE rom_num>1
;


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `rom_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,country, funds_raised_millions) as rom_num
FROM layoff_staging;

SELECT *
FROM layoff_staging2
WHERE rom_num>1;

DELETE
FROM layoff_staging2
WHERE rom_num>1;

SELECT *
FROM layoff_staging2;

-- STANDARIZING DATA

SELECT company, TRIM(company)
FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM layoff_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoff_staging2
SET industry='Crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT(country)
FROM layoff_staging2
ORDER BY 1;

SELECT DISTINCT(country)
FROM layoff_staging2
WHERE country LIKE 'united states%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT distinct country
from layoff_staging2
order by 1;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoff_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;

UPDATE layoff_staging2
SET industry=NULL
WHERE industry='';


SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry='';

SELECT *
FROM layoff_staging2
WHERE company ='Airbnb';

SELECT t1.industry, t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoff_staging2
order by 1;

ALTER TABLE layoff_staging2
DROP COLUMN rom_num; 