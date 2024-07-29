
# data cleaning
select *
from layoffs
;

# 1. Remove duplicates
# 2. standarized the data
# 3. NUll values or blank values 
# 4. Remove any columns  




# its alwayws better to creaate a copy of orginal tables 
create table layoffs_new
like layoffs;       # this will create the headings of the orignal table 

insert layoffs_new
select *
from layoffs;


select *,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,'date') as row_num

from layoffs_new
;



with duplicate_cte2 as
(
select *,
row_number() over(
partition by company,location,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num

from layoffs_new

)
select *
from duplicate_cte2
where row_num > 1;

# removing duplicates





CREATE TABLE `layoffs_new_up` (
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

select *
from layoffs_new_up
where row_num > 1;

insert into layoffs_new_up
select *,
row_number() over(
partition by company,location,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num

from layoffs_new;

SET SQL_SAFE_UPDATES = 0;


delete 
from layoffs_new_up
where row_num > 1;


select *
from layoffs_new_up
;
-- stndarisiings  data 
-- use trim  and update into regular format 

select trim(company)
from layoffs_new_up
;
update layoffs_new_up 
set company = trim(company)
;

update layoffs_new_up
set industry = 'Crypto'    # make simialr industries into one to make easy during visualization 
where industry like 'Crypto%';

select distinct trim( trailing '.' from country)
from layoffs_new_up
order by 1
;

update layoffs_new_up
set country = trim( trailing '.' from country)
where country like 'United States%'
;


select date#this function has to be in this  format only otherwise its gonna give  us an error 
from layoffs_new_up
;

update layoffs_new_up
set date = str_to_date(date,'%m/%d/%Y');  ## method to chhange date from text to date format 

alter table layoffs_new_up
modify column date Date;



-- getting rid of null and blank values 
# make sure to check all the column if it has missing values which can be filled based on similar columns
# if u find any change them into null first and then go along the process

update layoffs_new_up
set industry = null
where industry = '';


select t1.industry,t2.industry
from layoffs_new_up t1
join layoffs_new_up t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;

update  layoffs_new_up t1
join layoffs_new_up t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;



# checke the most imp thing fromt this data if the laid off is null ornot 


select * #  this dta is useless  bcs  they never had any lay offs which doesnt make sense in this database 
from layoffs_new_up
where total_laid_off is null
and percentage_laid_off is null
;


# removing columns and rows 
delete #make sure to check before deleting that if they are usefull or not 
from layoffs_new_up
where total_laid_off is null
and percentage_laid_off is null
;


alter table layoffs_new_up
drop column row_num;

select * 
from layoffs_new_up

;








