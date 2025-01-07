use world_lyfs;
select * from layoffs;

-- 1 REMOVE DUPLICATES
-- 2 STANDARDIZE THE DATA
-- 3 NULL VALUES OR BLANK VALUES 
-- 4 REMOVE ANY COLUMNS 

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * FROM 
layoffs;

-- 1. Finding Duplicates Values
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

-- CTE 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *FROM duplicate_cte
where row_num > 1;

select * from 
layoffs_staging 
where company= 'Casper';

-- Delete diplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 	
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from 
layoffs_staging2;
select *from 
layoffs_staging2
where row_num >1;
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE from 
layoffs_staging2
where row_num >1;
select * from 
layoffs_staging2;

-- STANDARDIZING DATA 
SELECT company, TRIM(company) FROM
layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

select * from 
layoffs_staging2;

SELECT distinct industry FROM
layoffs_staging2
order by 1;

SELECT * FROM
layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry  LIKE 'Crypto%';

SELECT * FROM
layoffs_staging2
WHERE country LIKE 'United States%'
order by 1;
SELECT distinct country, TRIM(TRAILING 	'.' FROM country) FROM
layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING 	'.' FROM country)
where country LIKE 'United States%';



SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

SELECT 
    `date`,
    CASE
        WHEN `date` LIKE '%-%-%' AND LENGTH(`date`) = 10 AND SUBSTRING_INDEX(`date`, '-', 1) BETWEEN '1900' AND '2099'
            THEN `date` -- Already in YYYY-MM-DD format
        WHEN `date` LIKE '%-%-%' AND LENGTH(`date`) = 10
            THEN STR_TO_DATE(`date`, '%m-%d-%Y') -- Convert MM-DD-YYYY to YYYY-MM-DD
        ELSE NULL -- Handle invalid dates if necessary
    END AS standardized_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = CASE
    WHEN `date` LIKE '%-%-%' AND LENGTH(`date`) = 10 AND SUBSTRING_INDEX(`date`, '-', 1) BETWEEN '1900' AND '2099'
        THEN `date` -- Already in YYYY-MM-DD format
    WHEN `date` LIKE '%-%-%' AND LENGTH(`date`) = 10
        THEN DATE_FORMAT(STR_TO_DATE(`date`, '%m-%d-%Y'), '%Y-%m-%d') -- Convert and format
    ELSE NULL -- Handle invalid dates if necessary
END
WHERE `date` LIKE '%-%-%';


select date from layoffs_staging2;
select *
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y/%d/%m')
WHERE `date` LIKE '%M/%d/%y';

SELECT `date` 
from layoffs_staging2;
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry is null 
OR industry = '';

SELECT * from layoffs_staging2
WHERE company LIKE 'Bally%';	


SELECT T1.company,T2.company , T1.industry, T2.industry
FROM layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2
	ON T1.company = T2.company 
WHERE (T1.industry IS NULL OR T1.industry = '')
AND T2.industry IS NOT NULL; 

UPDATE layoffs_staging2
SET industry = null
where industry = '';

UPDATE layoffs_staging2  T1
JOIN layoffs_staging2 AS T2
	ON T1.company = T2.company 
SET T1.industry = T2.industry    
WHERE T1.industry IS NULL
AND T2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry is NULL
or industry = ''; 

SELECT * FROM layoffs_staging2;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP column row_num;









