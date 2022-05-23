select * 
from PortfolioProject.dbo.CovidDeaths
where continent is nto null
order by 3,4


select * 
from PortfolioProject.dbo.CovidVaccination
order by 3,4

--select data that we will be using

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.dbo.CovidDeaths
order by 1,2

--percentage of dying in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from PortfolioProject.dbo.CovidDeaths
where location like '%india%'
order by 1,2


--looking at total cases vs population
--shows what percent of population has covid
select location,date,population, total_cases,round((total_cases/population)*100,6) as PercentofPopulationInfected
from PortfolioProject.dbo.CovidDeaths
--where location like '%india%'
order by 1,2


--looking at countries with highest infection rates  compared to population
select location,population, max(total_cases) as HighestInfectionCount,max(round((total_cases/population)*100,6)) as PercentofPopulationInfected
from PortfolioProject.dbo.CovidDeaths
--where location like '%india%'
group by location,population
order by PercentofPopulationInfected desc


--looking at countries with highest death count per population (continent not null removes those country grouping results which can be seen if we remove this not null line) 
select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order by HighestDeathCount desc



select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
--where location like '%india%'
where continent is null
group by location
order by HighestDeathCount desc



--global numbers
select date,sum(new_cases) as total_deaths,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2



--looking at total population vs total vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPropleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2,3



--USE CTE to calculate percentage of people vaccinated

with popvsvac (continent,location,date,population,new_vaccinations, RollingPeopleVaccinated)
as
(
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths dea
	join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 from popvsvac

--Creating view to use the tables for vizualization
create view PercentagePeopleVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths dea
	join PortfolioProject..CovidVaccinations vac 
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null

select * from PercentagePeopleVaccinated











































