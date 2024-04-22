

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


--3. If we were to remove all interest_id values which are lower
--than the total_months value we found in the previous question - how many total data points would we be removing?

with cte_a as (
select 
	interest_id
from [E8].[interest_metrics]
where interest_id is not null
group by interest_id
having count(distinct month_year)<6
)
SELECT
  COUNT(*) AS removed_rows
FROM e8.interest_metrics 
where interest_id in (
SELECT interest_id
  FROM cte_a
  )


--4. Does this decision make sense to remove these data points from a business perspective? 
--Use an example where there are all 14 months present to a removed interest example for your arguments 
--- think about what it means to have less months present from a segment perspective.

with cte_a as (
select 
	interest_id
from [E8].[interest_metrics]
where interest_id is not null
group by interest_id
having count(distinct month_year)<14
)
SELECT
  COUNT(*) AS removed_rows
FROM e8.interest_metrics 
where interest_id in (
SELECT interest_id
  FROM cte_a
  )

