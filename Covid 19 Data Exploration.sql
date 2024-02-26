/*
Covid 19 Data Exploration
*/

select * From CovidProject..[CovidDeaths]
where continent is not null
Order by 3,4


--select * From CovidProject..[CovidVaccinations]
--Order by 3,4


--# select data that am using

select location, date, total_cases, new_cases, total_deaths, population
From CovidProject..[CovidDeaths]
where continent is not null
Order by location, date


--# Looking at Total cases vs Total deaths

select location, date, total_cases, total_deaths
from CovidProject..[CovidDeaths]
where continent is not null
order by location, date

select * from [CovidDeaths]

ALTER Table [CovidDeaths]
ALTER Column total_cases FLOAT

ALTER Table [CovidDeaths]
ALTER Column total_deaths FLOAT

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..[CovidDeaths]
where continent is not null
order by location, date


--# Looking at Total cases vs Total Deaths in the United States

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..[CovidDeaths]
where location like '%states%' and continent is not null
order by location, date


--# Looking at the Total cases vs population
--# Shows the percentage of population that got Covid

select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from CovidProject..[CovidDeaths]
where continent is not null
order by location, date


--# Shows the percentage of population for United States that got Covid

select location, date, population, total_cases, (total_cases/population)*100 as PopulationPercentage
from CovidProject..[CovidDeaths]
where location like '%states%' and continent is not null
order by location, date


--# Countries with the highest infection rates over population

select location, population, MAX(total_cases) as HighestTotalCases , MAX((total_cases/population))*100 as PopulationPercentage
from CovidProject..[CovidDeaths]
where continent is not null
group by location, population
order by PopulationPercentage DESC


--# Showing the Total deaths for Countries per population

select location, MAX(total_deaths) as TotalDeathCount
from CovidProject..[CovidDeaths]
where continent is not null
group by location
order by TotalDeathCount DESC

--# Break things by continent
--# Showing Continents with highest Death count

select continent, MAX(total_deaths) as TotalDeathCount
from CovidProject..[CovidDeaths]
where continent is not null
group by continent
order by TotalDeathCount DESC 


--# Global Numbers

select SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths,
SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
From CovidProject..[CovidDeaths]
where continent is not null
--group by date
Order by 1, 2



--# Joining the two tables CovidDeaths and CovidVaccinations

select * from CovidProject..[CovidDeaths] d join
CovidProject..[CovidVaccinations] v
on d.date = v.date


--# Looking at Total population vs Vaccinations

select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date) as RollingPpleVacinnated
--,(RollingPpleVacinnated/population)*100
from CovidProject..[CovidDeaths] d join 
CovidProject..[CovidVaccinations] v
on d.date = v.date
where d.continent is not null
order by 2,3


--# Using CTE

with PvsV (continent, location, date, population, new_vaccinations, RollingPpleVacinnated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date) as RollingPpleVacinnated
-- (RollingPpleVacinnated/population)*100
from CovidProject..[CovidDeaths] d join
CovidProject..[CovidVaccinations] v
on d.date = v.date
where d.continent is not null
-- order by 2,3
)
select *, (RollingPpleVacinnated/population)*100
from PvsV


--# Create View for visualisation

Create View GlobalNumbers as
select SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths,
SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
From CovidProject..[CovidDeaths]
where continent is not null
--group by date
--Order by 1, 2

Create View PercentPopulationVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date) as RollingPpleVacinnated
-- (RollingPpleVacinnated/population)*100
from CovidProject..[CovidDeaths] d join
CovidProject..[CovidVaccinations] v
on d.date = v.date
where d.continent is not null
-- order by 2,3