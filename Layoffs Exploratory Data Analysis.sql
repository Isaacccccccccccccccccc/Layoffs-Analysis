-- Exploratory Data Analysis

Use PortfolioProject;

Select * from layoffs;

Select Max(total_laid_off), Max(percentage_laid_off) from layoffs;

Select * from layoffs
Where percentage_laid_off = 1
Order by total_laid_off Desc;

Select industry, Sum(total_laid_off) from layoffs
Group by industry
Order by 2 Desc;

Select country, Sum(total_laid_off) from layoffs
Group by country
Order by 2 Desc;

Select Year(date), Sum(total_laid_off) from layoffs
Group by Year(date)
Order by 1 Desc;

With MonthlyTotalLayoffs as (
	Select Date_format(date, '%Y-%m') as month, Sum(total_laid_off) as month_off from layoffs
	Where Date_format(date, '%Y-%m') is not null
	Group by month
	-- Order by 1
)
Select month, month_off, Sum(month_off) over (Order by month)
from MonthlyTotalLayoffs;

Select company, Year(date), Sum(total_laid_off) from layoffs
Group by company, Year(date)
Order by company Asc;

With CompanyYearlyLayoffs (company, year, year_off) as (
	Select company, Year(date), Sum(total_laid_off) from layoffs
	Group by company, Year(date)
), 
CompanyYearRank as (
	Select *, Dense_rank() over (Partition by year Order by year_off Desc) as ranking from CompanyYearlyLayoffs
	Where year is not null
)
Select * from CompanyYearRank
Where ranking <= 5;
-- We Can Also Exchange 'company' with Orther Columns Like 'industry'
	 























