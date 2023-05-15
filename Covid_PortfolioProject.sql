--Select * from CovidVaccinations
--order by 3,4


Select * 
from SQLPortfolioProject.dbo.CovidDeaths 
where continent is not null
order by 3,4

--Selecting the data

select location,date, total_cases, new_cases, population
From SQLPortfolioProject.dbo.CovidDeaths  
Order By 1,2

--Looking at Total cases Vs. Total Deaths

select location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage, population
From SQLPortfolioProject.dbo.CovidDeaths 
Where location like '%India%' and continent is not null
Order By 1,2

--Looking at total cases vs population
-- shows a percentage of population got Covid

select location,date, total_cases, total_deaths,(total_deaths/population)*100 PopulationPercentage, population as TotalPopulation
From SQLPortfolioProject.dbo.CovidDeaths 
--Where location like '%India%'
where total_deaths  is not null
Order By 1,2


-- Looking at countries with highest Cases per population

select location,population, MAX(total_cases)as highestCases, MAX((total_cases/population))*100 as 
	PopulationInfectedPercentage
From SQLPortfolioProject.dbo.CovidDeaths 
--Where location like '%India%'
where continent is not null
Group by location,population
Order By PopulationInfectedPercentage desc

--showing countries death rate per population

select location, MAX(cast(total_deaths as int))as TotalDeathCount
From SQLPortfolioProject.dbo.CovidDeaths 
--Where location like '%India%'
where continent is not null
Group by location
Order By TotalDeathCount desc

--Based on continent

select location, MAX(cast(total_deaths as int))as TotalDeathCount
From SQLPortfolioProject.dbo.CovidDeaths 
where continent is  null
Group by location
Order By TotalDeathCount desc

--calculating total no. cases, deaths and Death_percentage
-- Global Numbers

select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int))as TotalDeathCount, 
	Sum(cast(new_deaths as int))/Sum(New_cases) * 100 AS TotalDeathPercentage
From SQLPortfolioProject.dbo.CovidDeaths 
where continent is not null
--Group by 
Order By 1,2





--Looking at Total Population VS Vaccination

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations))	OVER (partition BY dea.location Order by dea.location,
dea.date) as TotalPeopleVaccinated
--(TotalPeopleVaccinated/dea.population)*100
from SQLPortfolioProject.dbo.CovidDeaths dea
join SQLPortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
and vac.new_vaccinations is not null
order by 2,3

--Using CTE

with popvsvac (continent,location,date,population, new_vaccination,TotalPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations))	OVER (partition BY dea.location Order by dea.location,
dea.date) as TotalPeopleVaccinated
--(TotalPeopleVaccinated /dea.population)*100
from SQLPortfolioProject.dbo.CovidDeaths dea
join SQLPortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--and vac.new_vaccinations is not null
--order by 2,3
)
select *,  (TotalPeopleVaccinated /population)*100 as percentpopulationvacc
from popvsvac


--Temp Table


Create table #PercentPeoplevaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
TotalPeopleVaccinated numeric
)
INSERT INTO #PercentPeoplevaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations))	OVER (partition BY dea.location Order by dea.location,
dea.date) as TotalPeopleVaccinated
--(TotalPeopleVaccinated /dea.population)*100
from SQLPortfolioProject.dbo.CovidDeaths dea
join SQLPortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--and vac.new_vaccinations is not null
--order by 2,3

select *,  (TotalPeopleVaccinated /population)*100 as percentpopulationvacc
from #PercentPeoplevaccinated



--Creating View to store data for later visualisation

Create View PercentPeoplevaccinated as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations))	OVER (partition BY dea.location Order by dea.location,
dea.date) as TotalPeopleVaccinated
--(TotalPeopleVaccinated /dea.population)*100
from SQLPortfolioProject.dbo.CovidDeaths dea
join SQLPortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--and vac.new_vaccinations is not null
--order by 2,3

select * 
from PercentPeoplevaccinated


















