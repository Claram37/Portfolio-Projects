SELECT *
FROM layoffs;

-- creating a staging table to avoid making changes to the raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

-- inserting data from the layoffs table to the staging table
INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT *,
row_number() over (
partition by company, industry, total_laid_off, percentage_laid_off,'date')AS row_num
FROM layoffs_staging;

-- creating a CTE to store data that has duplicate rows
WITH duplicate_cte AS
(
SELECT *,
row_number() over (
partition by company,location, industry, total_laid_off, percentage_laid_off,'date', stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- Remove duplicates
WITH duplicate_cte AS
(
SELECT *,
row_number() over (
partition by company,location, industry, total_laid_off, percentage_laid_off,'date', stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

-- creating a new table to delete the duplicate rows
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

select *
from layoffs_staging2
where row_num > 1;

insert into layoffs_staging2
SELECT *,
row_number() over (
partition by company,location, industry, total_laid_off, percentage_laid_off,'date', stage,country,funds_raised_millions)AS row_num
FROM layoffs_staging;

DELETE
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;

-- Standardizing data

-- Removing extra spaces on the company names
Select company,trim(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

-- removing the '.' after United States
update layoffs_staging2
set country = trim(trailing '.' from country);

Select distinct country
from layoffs_staging2
order by 1;

-- checking the industry column
Select distinct industry
from layoffs_staging2
order by industry;

-- Changing the industry with the word crypto to make them the same
Select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry in ('Crypto Currency', 'CryptoCurrency');

-- checking null and empty values in the industry column
Select *
from layoffs_staging2
where industry IS NULL
OR industry = ''
order by industry;

--  changing the empty values to null for easy populating
update layoffs_staging2
set industry = NULL
where industry = '';

-- populating the null values
update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry IS NULL
and t2.industry IS NOT NULL;

-- changing the date column to string
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- converting the date type appropriately
Alter table layoffs_staging2
modify column `date` date;

select * 
from layoffs_staging2;

select * 
from layoffs_staging2
where total_laid_off IS NULL;

select * 
from layoffs_staging2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

-- deleting all rows that have both total_laid_off and percentage_laid_off as NULL
delete from layoffs_staging2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

Alter table layoffs_staging2
drop column row_num;

select * 
from layoffs_staging2;

-- checking the maximum number in the total_laid_off column
select max(total_laid_off)
from layoffs_staging2;

-- checking the maximum and the minimum percentage laid off
select max(percentage_laid_off), min(percentage_laid_off)
from layoffs_staging2
where percentage_laid_off IS NOT NULL;

-- this are the companies that had the highest percentage laid off
select *
from layoffs_staging2
where percentage_laid_off = 1;

-- this is ordering the companies according to the funds they had raised in millions
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- companies with the biggest lay off in a single day
select company, total_laid_off
from layoffs_staging2
order by total_laid_off desc
limit 5;

-- companies with the biggest lay off in total
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
limit 10;

-- locations with the biggest lay off in total
select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 desc
limit 10;

-- total layoffs done in four years (the dataset has data from 2020 to 2023)
-- by country
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- by year
select YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by YEAR(date)
order by 1 asc;

-- by industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- by stage
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- company with the most layoffs per year
WITH Company_Year AS(
select company, YEAR(date) as years, sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by company, YEAR(date)
),
Company_Year_Rank AS (
select company,years, total_laid_off, rank() over (
partition by years 
order by total_laid_off desc) as ranking
from Company_Year
)
select company, years, total_laid_off, ranking
from Company_Year_Rank
where ranking <= 3
and years IS NOT NULL
order by years asc, total_laid_off desc;

-- total layoffs per month
select substring(date,1,7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by dates
order by dates asc;

WITH DATE_CTE AS
(
select substring(date,1,7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by dates
order by dates asc
)
select dates, sum(total_laid_off) over (order by dates asc) as rolling_total_layoffs
from DATE_CTE
order by dates asc;