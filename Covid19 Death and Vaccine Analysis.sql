-- select all
 
 USE dbo.Covid_death
--select the data to be used

select location, date, total_cases, new_cases, total_deaths, population 
FROM dbo.Covid_death
order by 1, 2


ALTER TABLE dbo.Covid_death
ALTER COLUMN total_deaths INT
ALTER COLUMN total_cases TYPE INT



-- Comparing the total cases and total deaths
select location, date, total_cases, total_deaths, 
CAST(total_deaths AS NUMERIC) / CAST(total_cases AS NUMERIC) * 100 AS DeathPercentage
FROM dbo.Covid_death
order by 1,2

--checking for the death rates in specific countries like United Kingdom
select location, date, total_cases, total_deaths, 
CAST(total_deaths AS NUMERIC) / CAST(total_cases AS NUMERIC) * 100 AS DeathPercentage
FROM dbo.Covid_death
WHERE location like '%KINGDOM%'
order by 1,2


--what percentage of the population has covid?
select location, date,  population, total_cases,
CAST(total_cases AS NUMERIC) / CAST(population AS NUMERIC) * 100 AS PopulationPercentage
FROM dbo.Covid_death
WHERE location like '%KINGDOM%'
order by 1,2

--top ten countries with the highest infection rate compared to the population
select TOP (10)
location, population, MAX(total_cases) AS HighestInfectionCount,
MAX(CAST(total_cases AS NUMERIC) / CAST(population AS NUMERIC)) * 100 AS MaxInfectionRate
FROM dbo.Covid_death
GROUP BY location, population
order by MaxInfectionRate desc


--countries with the highest death count per population
select location,  MAX(total_deaths) AS TotalDeathCount
FROM dbo.Covid_death
where continent is null
GROUP BY location
order by TotalDeathCount desc

--drill down to continents with the highst death rate
select continent,  MAX(total_deaths) AS TotalDeathCount
FROM dbo.Covid_death
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

--death percentage by date accross the world
-- encountered this error " Msg 8134, Level 16, State 1, Line 62 Divide by zero error" and solved it by using the coalesce and null if function
select date, SUM(new_cases) AS Total_cases, SUM(new_deaths) AS total_deaths,
 COALESCE(SUM(CAST(new_deaths AS NUMERIC))/NULLIF(SUM(CAST(new_cases AS NUMERIC)),0),0) *100 AS DeathPercentage
FROM dbo.Covid_death
where continent is not null
GROUP BY date
order by 1,2


-- total cases in the world
select  SUM(CAST(new_cases AS NUMERIC)) AS Total_cases, SUM(CAST(new_deaths AS NUMERIC)) AS total_deaths,
SUM(CAST(new_deaths AS NUMERIC))/SUM(CAST(new_cases AS NUMERIC)) *100 AS DeathPercentage
FROM dbo.Covid_death
where continent is not null
order by 1,2



--JOINING THE COVID DEATH AND COVID VACCINATION TABLE

SELECT *
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date

--TOTAL POPULATION AGAINST THE TOTAL VACCINATION (no null values in the continent column)
--step1: select the fields to be worked on
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- step2: sum the vaccinations on a daily by the location
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  as IteratedVaccination
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--step3: USE CTE

WITH PopulationVaccinated (continent,location,date,population,new_vaccinations, IteratedVaccination)
as
(
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  as IteratedVaccination
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (IteratedVaccination/population)*100 AS PercentedPopulationVaccinated
from PopulationVaccinated


--USING TEMP TABLE TO DO THE ABOVE
DROP Table if exists #PercentedPopulationVaccinated
CREATE Table #PercentedPopulationVaccinated

(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
IteratedVaccination numeric
)

Insert into #PercentedPopulationVaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  as IteratedVaccination
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (IteratedVaccination/population)*100 AS PercentPopulationVaccinated
from #PercentedPopulationVaccinated


--CREATING VIEWS

Create VIEW PopulationVaccinated as

SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  as IteratedVaccination
FROM dbo.Covid_death dea
JOIN dbo.Covid_vaccine vac
ON dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


-- Tableu query
--1
SELECT SUM(CAST(new_cases AS NUMERIC)) AS Total_cases, SUM(CAST(new_deaths AS NUMERIC)) AS Total_death, SUM(CAST(new_deaths AS NUMERIC))/SUM(CAST(new_cases AS NUMERIC))*100
as DeathPercentage
FROM dbo.covid_death
where continent is not null
order by 1, 2

--2

SELECT location, SUM(CAST(new_deaths AS NUMERIC)) AS TotalDeathCount
FROM dbo.covid_death
where continent is null
and location not in ('world', 'international', 'European union', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location
order by 2 desc

--3
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, Max(CAST(total_cases AS NUMERIC)/CAST(population AS NUMERIC)) * 100 as PercentPopulationInfected
FROM dbo.covid_death
GROUP BY location, population
order by 4 desc

--4
SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, Max(CAST(total_cases AS NUMERIC)/CAST(population AS NUMERIC)) * 100 as PercentPopulationInfected
FROM dbo.covid_death
where location not in ('world', 'international', 'European union', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location, population, date
order by 4 desc