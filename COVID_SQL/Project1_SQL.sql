--select *
--from PortfolioProjects..CovidDeaths

--select *
--from PortfolioProjects..CovidVaccinations

-- Selecting the data that I will be using

select location, date, total_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 1, 2

-- Looking at the total cases versus total deaths
select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as DeathPercentage
from PortfolioProjects..CovidDeaths
order by 1, 2

-- Checking Australia's Results
-- Showing the Likelihood of dying from COVID-19 in Australia
select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)) * 100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location = 'Australia'
order by 1, 2

-- Looking the Total Cases versus the Population
select location, date, total_cases, population, (cast(total_cases as float)/cast(population as float)) * 100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location = 'Australia'
order by 1, 2

--Looking at Total Deaths versus Population

select location, date, total_deaths, population, (cast(total_deaths as float)/cast(population as float)) * 100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location = 'Australia'
order by 1, 2

-- Which Country has the highest Infection Rate compared to Population

select location, population, Max(total_cases) as HighestInfectionCount, Max(cast(total_cases as float)/cast(population as float)) as CasesPercentage
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is not null
group by Location, population
order by 4 desc

-- Countries with the highest Death Count per population

select location, population, Max(total_deaths) as HighestDeathCount, Max(cast(total_deaths as float)/cast(population as float)) as DeathPercentPerPopulation
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is not null
group by Location, population
order by 4 desc

-- Countries with the Highest Number of deaths

select location, Max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is not null
group by Location
order by HighestDeathCount desc

-- Noticed that some of the figures show Continents as location

--select *
--from PortfolioProjects..CovidDeaths
--where continent is not null
--order by 3, 4

-- Looking and breaking things down by Continent

select continent, Max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is not null
group by continent
order by HighestDeathCount desc

--  Querying the numbers associated above

select location, Max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is null
group by location
order by HighestDeathCount desc

-- Showing the continents with the highest death counts per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
-- where location = 'Australia'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers

select Location, date, total_cases, total_deaths, 
	(cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1, 2


select date, sum(new_cases) as TotaCases, sum(cast(new_deaths as int)) as TotalDeaths, 
	case when sum(new_cases) = 0
		 then Null
		 else (sum(cast(new_deaths as int))/sum(new_cases)) * 100
		 end as DeathPercentage
from PortfolioProjects..CovidDeaths
-- where location like '%states%'
where continent is not null
group by date
order by 1, 2

select sum(new_cases) as TotaCases, sum(cast(new_deaths as int)) as TotalDeaths, 
	case when sum(new_cases) = 0
		 then Null
		 else (sum(cast(new_deaths as int))/sum(new_cases)) * 100
		 end as DeathPercentage
from PortfolioProjects..CovidDeaths
-- where location like '%states%'
where continent is not null
-- group by date
order by 1, 2

-- Now Looking at COVID Vaccinations

select *
from PortfolioProjects..CovidVaccinations

-- Joining tables CovidDeaths and Covid Vaccinations
--  on location and date

select *
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Roling People Vaccinated per day

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float))  
over (Partition by dea.location Order by dea.Location, dea.date) as RollingVacCount
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Using a CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVacCount)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float))  
over (Partition by dea.location Order by dea.Location, dea.date) as RollingVacCount
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)

select *, (RollingVacCount/population) * 100 as RollingPopVacPercent
from PopvsVac

-- Doing the same calculations using a Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVacCount numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float))  
over (Partition by dea.location Order by dea.Location, dea.date) as RollingVacCount
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *, (RollingVacCount/Population) * 100 as RollingPopVacPercent
from #PercentPopulationVaccinated 


--Creating View to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float))  
over (Partition by dea.location Order by dea.Location, dea.date) as RollingVacCount
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3

select *
from PercentPopulationVaccinated
