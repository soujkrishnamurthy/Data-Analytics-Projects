--Data exploration from deaths table
select * from deaths
select location, date, new_cases, total_deaths, population
from deaths
--New cases Vs population
select location, date, new_cases, population (new_cases/population)*100
from deaths
where location = 'India'

--countries with highest deaths rates vs population
select location, max(cast(total_deaths as decimal)) as highestdeaths
from deaths
where ((total_deaths is not null and continent is not null)) 
group by location
order by highestdeaths desc
Limit 20;

---Break up by continent 'Asia'
select location, max(cast(total_deaths as decimal)) as highestdeaths
from deaths
where ((total_deaths is not null and continent = 'Asia')) 
group by location
order by highestdeaths desc;

-- Global death percentages 
select date, SUM(cast(new_cases as decimal)), sum(cast(new_deaths as decimal)), 
SUM(cast(new_deaths as decimal))/sum(cast(new_cases as decimal))*100 as deathpercentage
from deaths
where continent is not null
group by date
order by deathpercentage desc

--using JOIN function
--Looking at total population Vs vaccinations by rolling count
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
from deaths dea join vaccines vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--TEMP table
drop table if exists percentagevaccinated
create table percentagevaccinated
(
continent varchar(50), location varchar(50), date date, 
Population numeric, new_vaccinations numeric, 
Rollingpeoplevaccinated numeric
)
Insert into percentagevaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
from deaths dea join vaccines vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *, (Rollingpeoplevaccinated/population)*100
from percentagevaccinated

--creating view to store data for later visualisations
create view percentagevaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
from deaths dea join vaccines vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3















