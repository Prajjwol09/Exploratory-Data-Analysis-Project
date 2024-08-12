-- EXPLORATORY DATA ANALYSIS
SELECT *
FROM layoffs_staging2;


-- MAX AND MIN employees layoff
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Layoff by Company
SELECT company, SUM(total_laid_off) AS laid_off
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;


-- By Date
SELECT MAX(date), MIN(date)
FROM layoffs_staging2;


-- By Industry
SELECT industry, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- By Country
SELECT country, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), MAX(total_laid_off) AS lay_off
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC ;


-- By Stage
SELECT stage, MAX(total_laid_off) AS lay_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC ;


-- By Months and Years
SELECT SUBSTRING(date, 1,7) Years, SUM(total_laid_off) laid_off
FROM layoffs_staging2
WHERE substring(date, 1,7) IS NOT NULL
GROUP BY Years
ORDER BY 1 ;


-- Calculating Rolling Total Using CTE
WITH Rolling_total_cte AS 
(
SELECT SUBSTRING(date, 1,7) Years, SUM(total_laid_off) laid_off
FROM layoffs_staging2
WHERE substring(date, 1,7) IS NOT NULL
GROUP BY Years
ORDER BY 1
)

SELECT Years, laid_off, 
SUM(laid_off) OVER (ORDER BY Years) AS Rolling_total
FROM Rolling_total_cte;


SELECT company, YEAR(date), SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;


-- Using CTE
WITH Company_CTE(Company, Years, Laid_off_employees) AS
(
SELECT company, YEAR(date), SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date)
), 
Company_year_rank  AS
(
SELECT *, 
DENSE_RANK() OVER( PARTITION BY Years ORDER BY Laid_off_employees DESC) company_ranking
FROM Company_CTE
WHERE Years IS NOT NULL
)

SELECT *
FROM Company_year_rank
WHERE company_ranking <=5 ;


























