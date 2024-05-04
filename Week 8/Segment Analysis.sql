--1. Using our filtered dataset by removing the interests with less than 6 months worth of data
--, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? 
--Only use the maximum composition value for each interest but you must keep the corresponding month_year

with cte_a as (
SELECT
	a.month_year
,	b.interest_name
,	a.composition
,	ROW_NUMBER() OVER (PARTITION BY b.interest_name ORDER BY composition DESC) AS interest_rank
FROM e8.interest_metrics as a
INNER JOIN e8.interest_map as b
  ON a.interest_id = b.id
WHERE a.month_year IS NOT NULL
),
top10 as (
select top 10 *
from cte_a
where interest_rank=1
order by composition desc
)
, bottom10 as (
select top 10 *
from cte_a
where interest_rank=1
order by composition asc
)
, output as (
select *
from top10
union all
select *
from bottom10
)
select 
	month_year
,	interest_name
,	composition
from output
order by composition desc

--2.Which 5 interests had the lowest average ranking value?

select 
top 5 interest_name
,	avg(ranking*1.00) as avgR
,	count(interest_name) as CountR
from [E8].[interest_metrics] as a
full join [E8].[interest_map] as b
on a.interest_id=b.id
where month_year is not null
group by interest_name
order by avgR asc

-- 3. Which 5 interests had the largest standard deviation in their percentile_ranking value?	

with cte_a as (
SELECT
  a.interest_id
  ,	b.interest_name
  ,	STDEV(a.percentile_ranking) AS STDEV_PCR
  ,	COUNT(*) AS record_count
FROM e8.interest_metrics as a
INNER JOIN e8.interest_map as b
  ON a.interest_id = b.id
WHERE a.month_year IS NOT NULL
GROUP BY
  a.interest_id,
  b.interest_name
)
select top 5 interest_name
from cte_a
where STDEV_PCR is not null
order by STDEV_PCR desc
