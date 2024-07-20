--  Project Exploratory Analysis

-- This is based on the cleaned data from P1

select *
from layoffs_staging2;

-- Which company laid off the most people

select company, MAX(total_laid_off)
from layoffs_staging2
group by 1
order by 2 desc;

-- Looks like Google has that Honour with 12000
-- Looking at companies that went completely under, ie percentage laid off = 1

select company, total_laid_off, percentage_laid_off
from layoffs_staging2
where percentage_laid_off = 1
group by 1, 2
order by 2 desc;

-- Katerra Went uder loosing 2434 staff.

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- this result produced a different result that earlier in that Amazon laid off the most workers
-- Looking at the date rate of the current data

select min(`date`), max(`date`)
from layoffs_staging2;

--  Date range cover March 2020 till March 2023, this period covers a bit of the COVID-19 Pandemic
--  Looking at industries that were hit the hardest

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Consumer and Retail Industries were hit the hardestm however many others didnt fare well.
-- Viewing all the data again.

select *
from layoffs_staging2;

--  Which country had the most layoffs

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Wow!  The United States laid off the most people far surpassing India who has the greater population.
-- China laid off reatively few people in relation to their population.
-- United States 254874
-- India         35993
-- China          5905  Assuming these figures are believable.

-- Looking at the total laid offs per year

select year(`date`) country, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 1 desc;

-- Most of the laid offs occurred in 2022 with 160661 compared to 2023 with 125677
-- However this is looking at 3 months of the year in 2023 so 2023 was a really bad year.

--  Looking at the stage of the company

select stage, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 desc;

--  I guess it stands to reason that Post-IPO's would generate the greatest layoffs.
--  This is due to the necessary restructuring that goes no as a result of take-overs.

-- Looking ar rolling totals per month/

select substring(`date`, 1, 7) as Month, sum(total_laid_off) as Total_Laidoff
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by Month
order by 1;

-- Now for the Rolling total
-- Employing a CTE

with Rolling_Total_CTE as
(
select substring(`date`, 1, 7) as Month, sum(total_laid_off) as Total_Laidoff
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by Month
order by 1
)
select `Month`, Total_Laidoff, sum(Total_Laidoff) over(order by `Month`) as Rolling_Total
from Rolling_Total_CTE;

-- Determining the Rolling totals by date and company

-- Our Starting point. We need the Company, Month, Year, and total laid off

select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
ORDER BY company;

select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
ORDER BY 3 desc;


