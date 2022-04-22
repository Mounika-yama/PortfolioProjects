
select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3 ,4 

--select *
--from portfolioProject..CovidVaccinations
--order by 3, 4

--select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
where continent is not null
order by 1, 2


-- Looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, ( total_deaths/ total_cases) *100 as Deathpercentage
from portfolioproject..CovidDeaths
where location like '%states%'
 and continent is not null
order by 1, 2


-- Looking at Total Cases vs population
-- Shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/ population) *100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
order by 1,2


-- looking at countries with highest infection rate compared to population

select location,  population, max(total_cases) as HighestInfectionCount, max(total_cases/ population) *100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%India%'
group by  location,  population
order by PercentPopulationInfected desc


-- Showing countries with highest death count per population

select location, max(cast (total_deaths as int)) as  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order  by TotalDeathCount desc


--Let's  BREAK THINGS DOWN BY CONTINENT

select continent, max(cast (total_deaths as int)) as  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order  by TotalDeathCount desc


-- showing contintents with highest death count per population

select continent, max(cast (total_deaths as int)) as  TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order  by TotalDeathCount desc


-- GLOBAL NUMBERS

select  sum(new_cases) as total_cases, sum(cast(new_deaths as int )) as total_deaths, sum(cast(new_deaths as int)) / sum (new_cases)*100 as DeathsPercentage
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
--group by date
order by 1, 2


-- Looking at total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by  2, 3



--USE CTE 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by  2, 3 
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(225),
Location nvarchar(225),
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
--where dea.continent is not null
--order by  2, 3 

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating view to store date for later visualization

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
--where dea.continent is not null
--order by  2, 3 


select *
from PercentPopulationVaccinated