-- Data cleaning

-- 1-Remove Duplicates
-- 2-Standardize the data (توحيد البيانات)
-- 3-Null Values or blank values
-- 4-Remove Any columns

-- في الاول هنعمل جدول تاني علشان لو البيانات بوظناها يبقي معانا زي نسخه كدا
-- (1.remove_duplicated)

create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

select*
from layoffs_staging;


with duplicate_cte as 
(select *,
row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
 as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

-- هنا هنحذف التكرارات دي 
-- عملنا create statement من copy 

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from layoffs_staging2
where row_num >1
;

insert into layoffs_staging2
select *,
row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
 as row_num
from layoffs_staging;

select*
from layoffs_staging2
where row_num >1
;

delete
from layoffs_staging2
where row_num >1
;
select *
from layoffs_staging2;

-- (2.standardizing data)
-- شيلنا الفراغات اللي في الاول 
select distinct(company)
from layoffs_staging2;

update layoffs_staging2
set company =trim(company);

select *
from layoffs_staging2;
-- نغير اسم حاجه هي في الاساس حاجه واحده 

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct industry
from layoffs_staging2;

-- هنا بنحددله ان الفراغ اللي عايزين نشيله هو نقطه
select distinct country ,trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country =trim(trailing '.' from country)
where country like 'United States%';

-- هنغير نوعيه العمود الي تاريخ 

update layoffs_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date`DATE;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

select *
from layoffs_staging2
where industry is null 
or industry='';


select *
from layoffs_staging2
where company like 'Airbnb';

select t1.industry,t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

update layoffs_staging2
set industry =null 
where industry ='';


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

select *
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null
;

delete
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

select *
from layoffs_staging2;

-- تعدبل في البيانات 
-- حذف عمود
 alter table layoffs_staging2
 drop column row_num ;
 
 select *
from layoffs_staging2;

-- عندنا كان في مع كلمه open & paid رموز 
-- ف احنا شيلناها ب replace
-- مش هنعمل update علشان نكون مع الكورس 
select company,replace(replace(company,'&',''),'#','') as clean_company
from layoffs_staging2;