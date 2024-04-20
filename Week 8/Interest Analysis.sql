

--1. Which interests have been present in all month_year dates in our dataset?

with cte_a as (
select 
	interest_id
,   count(month_year) as CountOfM
from [E8].[interest_metrics]
where interest_id is not null
group by interest_id
)

Select	
	distinct CountOfM
,	count(interest_id) as NumOfInterest
from cte_a
group by CountOfM
order by CountOfM desc

--2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months 
--- which total_months value passes the 90% cumulative percentage value?


with cte_a as (
select 
	interest_id
,   count(month_year) as CountOfM
from [E8].[interest_metrics]
where interest_id is not null
group by interest_id
)
, Cte_b as (
Select	
	distinct CountOfM
,	count(interest_id) as NumOfInterest
from cte_a
group by CountOfM

)

select 
	*
,   Format((sum(numOfinterest) over (order by countOfM desc)*1.00/(Select sum(numOfinterest) from Cte_b)),'P2') as percentage
from Cte_b;
