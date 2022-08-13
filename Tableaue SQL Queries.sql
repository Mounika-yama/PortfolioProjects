 /*

 Quries used for tableau project

 */



 --1.

 select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provide
-- numbers are extremely close so we will keep them - The second includes "International" Location


--select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
---where location like '%states%'
--where location= 'world'
---group by date
--order by 1,2


--2.

-- We take these out as they are not included in the above quries and want to stay consistent
-- European Union is part of Europe

select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location like '%states%'
where continent is null
and location not in ('world', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--3.

select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
Group by location,population
order by PercentPopulationInfected


-- 4.


Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like'%states%'
Group by location, population, date
Order by PercentPopulationInfected desc








--1.

select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
        on dea.location = vac.location
		And dea.date = vac.date
Where dea.continent is not null
Group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




--2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Where continent is not null
--Group by date
order  by 1,2


-- Just a double check based off the data provide
--numbers are extremely close so we will keep them - The Second includes "International" Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
---where location like'%sates%'
--where location = 'World'
---Group by date
--Order by 1,2


-- 3.

-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is null
and location not in ('world', 'European union', 'International')
Group by location
order by TotalDeathCount desc



--4.

select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Group by location, population
order by PercentPopulationInfected desc



--5.

--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
---where location like '%states%'
--where continent is not null
--order by 1,2

--Took the above query and added population
select location, date, population, total_cases,total_deaths
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2


--6.


With PopvsVac (continent, Location, date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
         On dea.location = vac.location
		 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


--7.

select Location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
Group by Location, population, date
Order by PercentPopulationInfected desc



