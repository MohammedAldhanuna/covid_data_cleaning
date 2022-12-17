SELECT *
FROM covid.covid_deaths
WHERE continent is not null
ORDER BY 1,2;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid.covid_deaths
WHERE continent is not null
ORDER BY 1,2;

-- Select total cases vs total deaths

SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as deaths_precentage
FROM covid.covid_deaths
WHERE location like 'iraq' AND continent is not null
ORDER BY 1,2;

-- Looking ar total cases vs population


-- Looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as highest_infections, MAX((total_cases/population))*100 as infected_percentage 
FROM covid.covid_deaths
-- WHERE location like 'iraq'
WHERE continent is not null
Group By location, population
ORDER BY 4 desc;

-- Looking at countries with highest death rate compared to population

SELECT Location, MAX(total_deaths) as highest_deaths
FROM covid.covid_deaths
-- WHERE location like 'iraq'
WHERE continent is not null
Group By location
ORDER BY 2 desc;

-- Break dow by continent

SELECT continent, MAX(total_deaths) as highest_deaths
FROM covid.covid_deaths
-- WHERE location like 'iraq'
WHERE continent is not null
Group By continent
ORDER BY 2 desc;


-- Showing continent with hisghest death count per population

SELECT continent, MAX(100*total_deaths/population) as highest_deaths_per_population
FROM covid.covid_deaths
-- WHERE location like 'iraq'
WHERE continent is not null
Group By continent
ORDER BY 2 desc;

-- Breaking to global data

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 100*(SUM(new_deaths)/SUM(new_cases)) as deaths_precentage
FROM covid.covid_deaths
-- WHERE location like 'iraq' 
WHERE continent is not null
-- GROUP BY date
ORDER BY 1;


-- Total population vs vaccinations


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated,
100*people_vaccinated/population
FROM covid.covid_deaths dea
Join covid.covid_vaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null AND vac.new_vaccinations is not null
ORDER BY 2,3;


-- USE CTE

with PopvsVac(Continent, Location, Date, Population, new_vaccinations, vaccinated_people)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_v3accinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
-- 100*people_vaccinated/population
FROM covid.covid_deaths dea
Join covid.covid_vaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null -- AND vac.new_vaccinations is not null
-- ORDER BY 2,3
)
SELECT *, (vaccinated_people/population)*100
FROM PopvsVac;

-- TEMP TABLE
DROP TABLE IF exists covid.PercentPopulationVaccinated;
CREATE TABLE covid.PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_v3accinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
-- 100*people_vaccinated/population
FROM covid.covid_deaths dea
Join covid.covid_vaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null -- AND vac.new_vaccinations is not null
-- ORDER BY 2,3

SELECT *, (vaccinated_people/population)*100
FROM PercentPopulationVaccinated;