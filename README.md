# SQL_project


# Layoffs Data Cleaning Project

This repository contains SQL scripts for cleaning and preprocessing a dataset of company layoffs. The goal of this project is to remove duplicates, standardize data, handle null values, and remove unnecessary columns to prepare the dataset for further analysis and visualization.

Table of Contents
- [Introduction](#introduction)
- [Dataset](#dataset)
- [Requirements](#requirements)
- [Usage](#usage)
- [Steps](#steps)
  - [1. Remove Duplicates](#1-remove-duplicates)
  - [2. Standardize the Data](#2-standardize-the-data)
  - [3. Handle Null or Blank Values](#3-handle-null-or-blank-values)
  - [4. Remove Unnecessary Columns](#4-remove-unnecessary-columns)

Introduction
This project involves cleaning and preprocessing a dataset containing information about company layoffs. The cleaning process includes removing duplicates, standardizing the data, handling null or blank values, and removing unnecessary columns. The cleaned data will be ready for analysis and visualization.

Dataset
The dataset `layoffs` contains the following columns:
- company
- location
- industry
- total_laid_off
- percentage_laid_off
- date
- stage
- country
- funds_raised_millions

Requirements
To run the SQL scripts in this repository, you need a MySQL database. The SQL scripts are designed to work with MySQL.

Usage
To use the scripts, follow these steps:

1. Create a new table `layoffs_new` from the original `layoffs` table**:
    ```sql
    create table layoffs_new
    like layoffs;

    insert layoffs_new
    select *
    from layoffs;
    ```

2. Run the provided SQL scripts step by step to clean and preprocess the data**.

Steps
 1. Remove Duplicates
Duplicates are identified and removed based on certain columns (company, location, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions).

```sql
with duplicate_cte2 as (
  select *,
  row_number() over(
    partition by company,location,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
  from layoffs_new
)
select *
from duplicate_cte2
where row_num > 1;

-- Removing duplicates
create table layoffs_new_up as
select *
from duplicate_cte2
where row_num = 1;
```

2. Standardize the Data
Standardize the data by trimming whitespace and updating values for consistency.

```sql
update layoffs_new_up 
set company = trim(company);

update layoffs_new_up
set industry = 'Crypto'
where industry like 'Crypto%';

update layoffs_new_up
set country = trim(trailing '.' from country)
where country like 'United States%';

update layoffs_new_up
set date = str_to_date(date,'%m/%d/%Y');

alter table layoffs_new_up
modify column date Date;
```

 3. Handle Null or Blank Values
Handle null or blank values by setting appropriate default values or removing rows.

```sql
update layoffs_new_up
set industry = null
where industry = '';

update  layoffs_new_up t1
join layoffs_new_up t2
  on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

delete from layoffs_new_up
where total_laid_off is null
and percentage_laid_off is null;
```

 4. Remove Unnecessary Columns
Remove columns that are no longer needed.

```sql
alter table layoffs_new_up
drop column row_num;
```

