-- Load Data

Use PortfolioProject;

Truncate layoffs;

Load data local infile 'Users/shihaoliu/Documents/Data/layoffs.csv'
into table layoffs
character set utf8mb4
Fields terminated by ','
Optionally enclosed by '"'
Lines terminated by '\n'
Ignore 1 lines;

Select Count(*) from layoffs;

Select * from layoffs;


-- Add Primary Key Id

Alter table layoffs
add column id bigint unsigned not null auto_increment primary key first;


-- Remove Duplicats

With DuplicateRows as (
	Select *, Row_number() over (Partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
	from layoffs
)
Select * from DuplicateRows
Where row_num > 1;

With DuplicateRows as (
	Select *, Row_number() over (Partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
	from layoffs
)
Delete l 
from layoffs l
Join DuplicateRows d using (id)
Where d.row_num > 1;


-- Standardize data

Select company, Trim(company) from layoffs where company like ' %';

Update layoffs
set company = Trim(company);

Select distinct industry, Count(industry) from layoffs
Group by industry
Order by 1;

Update layoffs
set industry = 'Crypto'
Where industry like 'Crypto%';

Select distinct country, Count(company) from layoffs
Group by country
Order by 1;

Update layoffs
set country = Trim(Trailing '.' from country)
Where country like 'United States%';

Select date, Str_to_date(date, '%m/%d/%Y') from layoffs;

Update layoffs
set date = Str_to_date(date, '%m/%d/%Y');

Alter table layoffs
Modify column date Date;

Select * from layoffs l1
Join layoffs l2 using (company)
where (l1.industry is null or l1.industry = '')
and (l2.industry is not null and l2.industry <> '');

Update layoffs l1
Join layoffs l2 using (company)
set l1.industry = l2.industry
where (l1.industry is null or l1.industry = '')
and (l2.industry is not null and l2.industry <> '');

Select * from layoffs
where total_laid_off is null and percentage_laid_off is null;

Delete from layoffs
where total_laid_off is null and percentage_laid_off is null;


















