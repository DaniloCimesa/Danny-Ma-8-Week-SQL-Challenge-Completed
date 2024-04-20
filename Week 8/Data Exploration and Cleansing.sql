

--1.Update the fresh_segments.interest_metrics table by modifying the month_year 
--column to be a date data type with the start of the month?

select *, convert(date, _year+'-'+_month+'-01') as Date
from [E8].[interest_metrics]

--2.What is count of records in the fresh_segments.interest_metrics for each month_year 
--value sorted in chronological order (earliest to latest) with the null values appearing first?

With cte_a as (
select *, convert(date, _year+'-'+_month+'-01') as Date
from [E8].[interest_metrics]
)

select count(*), date
from cte_a
group by date
order by date 

--4. How many interest_id values exist in the fresh_segments.interest_metrics table 
--but not in the fresh_segments.interest_map table? What about the other way around?

select --*
	count(distinct interest_id) as CountMetrics
,	count(distinct id) as CountMap
,	count(case when a.interest_id is null then b.id else null end)  as not_in_metrics
,	count(case when b.id is null then a.interest_id else null end)	as not_in_map
from [E8].[interest_metrics] as a
full join [E8].[interest_map] as b
on a.interest_id=b.id

--5.Summarise the id values in the fresh_segments.interest_map by its total record count in this table

select 
	count(id) as Record_count
from [E8].[interest_map]

--6. What sort of table join should we perform for our analysis and why? 
--Check your logic by checking the rows where interest_id = 21246 
--in your joined output and include all columns from fresh_segments.interest_metrics 
--and all columns from fresh_segments.interest_map except from the id column.

select	--*
	a.*
,	b.interest_name
,	b.interest_summary
,	b.created_at
,	b.last_modified
from [E8].[interest_metrics] as a
full join [E8].[interest_map] as b
on a.interest_id=b.id
where interest_id=21246

--7.Are there any records in your joined table where the month_year value is before the created_at 
--value from the fresh_segments.interest_map table? Do you think these values are valid and why?

WITH cte_join AS (
SELECT
  a.*,
  convert(date, _year+'-'+_month+'-01') as Date,
  b.interest_name,
  b.interest_summary,
  b.created_at,
  b.last_modified
FROM e8.interest_metrics a
INNER JOIN e8.interest_map b
  ON a.interest_id = b.id
WHERE a.month_year IS NOT NULL
)
SELECT *
FROM cte_join
WHERE date<created_at
