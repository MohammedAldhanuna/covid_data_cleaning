/*

Queries used for Tableau Project

*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as death_percentage
From covid.covid_deaths
Where Location = 'Iraq' 
OR Location ='Jordan'
OR Location ='Lebanon'
OR Location ='Palestine'
OR Location ='Syria'
order by 1.2;

-- 2

Select Location, SUM(new_deaths) as TotalDeathCount
From covid.covid_deaths
Where Location = 'Iraq' 
OR Location ='Jordan'
OR Location ='Lebanon'
OR Location ='Palestine'
OR Location ='Syria'
Group by Location
order by 2 desc;


-- 3.


Select Location, Population, MAX(total_cases) as highest_infected,  Max((total_cases/population))*100 as percent_population_infected
From covid.covid_deaths
Group by Location, Population
order by percent_population_infected desc;


-- 4.


Select Location, Population, date, MAX(total_cases) as highest_infected,  Max((total_cases/population))*100 as percent_population_infected
From covid.covid_deaths
Group by Location, Population, date
order by percent_population_infected desc;