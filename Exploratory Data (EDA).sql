-- Exploratory Data Analysis

select *
from layoffs_staging2;

-- max of people laid_of companys

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;



select *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

-- sum of companys laid_off 
-- big companys laid_off 

select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


-- first & last Date laid_off

select min(`date`),max(`date`)
from layoffs_staging2;



select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- sum of country laid_off 
-- United States have most number of laid_off

select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- 2022 have most number laid_off

select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;


select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;



select company,sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- month laid_off

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc 
;


with Rolling_total as 
(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc 
)
select `month`,total_off
,sum(total_off) over(order by  `month`) as rolling_total
from Rolling_total;


select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;


-- most number of people laid_off by year

with company_year (company,years,total_laid_off) as 
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),Company_Year_Rank as 
(select*,
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select * 
from Company_Year_Rank
where Ranking <=5 
;