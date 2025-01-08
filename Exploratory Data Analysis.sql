use world_lyfs;

select * from
layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2;

select * from
layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions  desc;

select company, SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select MIN(`date`), MAX(`date`) 
from layoffs_staging2;

select industry, SUM(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, SUM(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc;

select stage, SUM(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select * from
layoffs_staging2;

SELECT company, total_laid_off
FROM world_lyfs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
SELECT company, SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
SELECT location, SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

SELECT country, SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

SELECT industry, SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM world_lyfs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;



 




