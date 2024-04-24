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
