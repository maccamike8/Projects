-- Project Data Cleaning

-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022






SELECT * 
FROM world_layoffs.layoffs;



-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT world_layoffs.layoffs_staging
SELECT * FROM world_layoffs.layoffs;

select *
from world_layoffs.layoffs;


-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways



-- 1. Remove Duplicates

# First let's check for duplicates



SELECT *
FROM world_layoffs.layoffs_staging
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		world_layoffs.layoffs_staging;



SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
-- let's just look at oda to confirm
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda'
;
-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate

-- these are our real duplicates 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

-- these are the ones we want to delete where the row number is > 1 or 2or greater essentially

-- now you may want to write it like this:

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
	percentage_laid_off,`date`, stage, country, funds_raised_millions
) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- one solution, which I think is a good one. Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
-- so let's do it!!

 

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
`row_num` INT
);

-- Testing the create table statement

select *
from world_layoffs.layoffs_staging2;

-- Populating the new table

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
	percentage_laid_off,`date`, stage, country, funds_raised_millions
) as row_num
FROM layoffs_staging;

-- now that we have this we can delete rows were row_num is greater than 2

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1
;

-- 2. Standardize Data

SELECT * 
FROM world_layoffs.layoffs_staging2;

select company, trim(company)
FROM world_layoffs.layoffs_staging2;

update  world_layoffs.layoffs_staging2
SET company = trim(company);

-- if we look at industry it looks like we have some null and empty rows, let's take a look at these

SELECT distinct(industry)
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

SELECT industry
from layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
from layoffs_staging2;
-- WHERE industry LIKE 'Crypto%';

-- Country looks good now

-- Looking at the Date column which is a text field

-- Converting the Date to a date field

select `date`
-- str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging2;

--  Date Column now looks good

-- Investigation Columns with NULL and Blank Values

SELECT total_laid_off, percentage_laid_off
FROM layoffs_staging2;
where total_laid_off is NULL
and percentage_laid_off is NULL
order by 1, 2;


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- let's take a look at these

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';
-- nothing wrong here


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'airbnb%';

-- it looks like airbnb is a travel, but this one just isn't populated.
-- I'm sure it's the same for the others. What we can do is
-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

-- we should set the blanks to nulls since those are typically easier to work with

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- now we need to populate those nulls if possible

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

select company, industry
from layoffs_staging2
where company like 'Airbnb%';

update layoffs_staging2
set industry = 'Travel'
where company = 'Airbnb';

--  Airbnb now looks ok

select company, industry
from layoffs_staging2
where (industry = null or industry = '');

-- there is now a need to look at Carvana and Juul
-- Looks like Carvana has some issues 
-- There is one row that has null values for boty total and percent laid off
-- This record on its own will not produce a meaningful result
--  This row I will delete

select *
from layoffs_staging2
where company = 'Carvana'
and (total_laid_off is null and percentage_laid_off is null);

delete from layoffs_staging2
where company = 'Carvana'
and (total_laid_off is null and percentage_laid_off is null);

select *
from layoffs_staging2
where company = 'Carvana';

update layoffs_staging2
set industry = 'Transportation'
where company = 'Carvana';

-- Company Carvana no looks great
-- Now checking out Company Juul

select * 
from layoffs_staging2
where company = 'Juul'
;

-- Looks like this is same company but different locations within the SF Bay area
-- Wull add "Consumer" to the vacant Industry location

update layoffs_staging2
set industry = 'Consumer'
where company = 'Juul'
and industry = ''
;

-- Company Juul looks good now

-- Checking Industry for null or blank values

select company, industry
from layoffs_staging2
where (industry = NULL or industry = '');

-- there are no NULL's or blanks in the industry column.  This is great

-- Checking other columns
select company, industry
from layoffs_staging2
where (company = NULL or company = '');

-- Both company and Industry are now populated



select location 
from layoffs_staging2
where location = null and location = '';

-- Location is now fine and populated

select company, total_laid_off, percentage_laid_off
from layoffs_staging2
where total_laid_off = '';

-- Checking all columns now having done both Company and Industry

select * 
from layoffs_staging2;

--  Am getting some misleading call for null values on the total_laid_off and Percentage_laid_off
-- Am going to change the null values to blank values

select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is null;

-- there are a lot of rows that come up with this query.alter
-- since we are looking at theses figures in our calculations, nothing meaningful can be derived from them
--  so will delete these rows

delete from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is null;

select * 
from layoffs_staging2;

-- total_laid_off is an integer and percentage_laid off is a text field
-- will change the null values in integer to blank. NOT DONE AS CLEARLY THIS WOULD PRODUCE INCONSISTENTIES
-- and the null in percentage_laid_off to blank as well as the datatye to float.
-- Will look at changing the datatype of percentage_laid_off to float

ALTER TABLE layoffs_staging2 


MODIFY percentage_laid_off FLOAT;

-- Finally the row_num Column is not required.  This can now be deleted

alter table layoffs_staging2
drop column row_num;
