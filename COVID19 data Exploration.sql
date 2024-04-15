Select *
From CovidVaccinations
where continent is not null
Order by 3,4

Select *
From CovidDeaths
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths,population
From PortfolioProject..CovidVaccinations
Order by 1,2

--Shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidVaccinations
Where location like '%Kenya%'
Order by 1,2

--Shows what percentage of the population got covid
Select location, date, population, total_cases,  (total_cases / population)*100 as InfectedPercentPopulation
From PortfolioProject..CovidVaccinations
--Where location like '%Kenya%'
Order by 1,2

--Shows the highest count of infected people in a country
Select location, population,MAX(total_cases) as HighestCount
From CovidVaccinations
Group by location, population
Order by HighestCount desc

--Countries with High infection rate compared to population
Select location, population, MAX(total_cases) As HighestInfectionCount, (MAX(total_cases) / population)*100 as InfectedPercentPopulation
From PortfolioProject..CovidVaccinations
--Where location like '%Kenya%'
Group by location,population
Order by InfectedPercentPopulation desc

--Countries with Highest Death Count compared to population
Select location, MAX(cast(total_deaths as int)) As HighestDeathCount
From PortfolioProject..CovidVaccinations
--Where location like '%Kenya%'
where continent is not null
Group by location
Order by HighestDeathCount desc

--Includes accurate information in terms of the data in the continents
Select location, MAX(cast(total_deaths as int)) As HighestDeathCount
From PortfolioProject..CovidVaccinations
--Where location like '%Kenya%'
where continent is null
Group by location
Order by HighestDeathCount desc

--Breaking down deaths by Continent
--Showing continents with the Highest Death Counts

Select continent, MAX(cast(total_deaths as int)) As HighestDeathCount
From PortfolioProject..CovidVaccinations
--Where location like '%Kenya%'
where continent is not null
Group by continent
Order by HighestDeathCount desc

--Global Numbers
--Worldwide deathPercentage
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths ,(CONVERT(float, SUM(new_deaths)) / NULLIF(CONVERT(float, SUM(new_cases)), 0)) as DeathPercentage
From PortfolioProject..CovidVaccinations
Where continent is not null
--Group by date
Order by 1,2

--Total Population VS Vaccinations
--Shows percentage of population that has been vaccinated

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 --Create a CTE so that the RollingPeopleVacinated column can be reused
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

--Creating a CTE to perform calculation on Partition by
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3
)
Select* ,(RollingPeopleVaccinated/population)*100 
from PopvsVac

-- using TempTable to perform calculations on Partition by
DROP Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccunations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3

Select *, (RollingPeopleVaccinated/population)*100 
from #PercentagePopulationVaccinated


--Creating a View to store data for later visualization
Create View PercentPopulationVaccinated 
as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select * 
from PercentPopulationVaccinated