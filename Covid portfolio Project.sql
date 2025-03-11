SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccination
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Total cases vs Total Deaths
-- Shows likelihood
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2 

--Total cases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
ORDER BY 1,2 

--Countries with highest infection rate compared to population
SELECT location, Population, MAX(total_cases)as HighestInfectionCount, (MAX(total_cases/population))*100 as 
HighestInfectionPercenatge
FROM PortfolioProject..CovidDeaths
GROUP BY location, Population
ORDER BY HighestInfectionPercenatge DESC

--Countries with highest death rate compared to population
SELECT location, MAX(cast(total_deaths as int))as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Group by continent 
SELECT continent, MAX(cast(total_deaths as int))as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC
-- Global numbers 
SELECT sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as
DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
--GROUP BY
ORDER BY 1,2
-- Total population vs Vaccinations


With PopsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopsVac

--temp table
DROP TABLE if exists #PercentPoupulationVaccinated
Create table #PercentPoupulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPoupulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date= vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPoupulationVaccinated

--creating view for data visualization
CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(Convert(int,vac.new_vaccinations)) over(partition by dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated