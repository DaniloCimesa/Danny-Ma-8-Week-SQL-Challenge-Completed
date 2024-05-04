

--1.What is the top 10 interests by the average composition for each month?
with cte_a as (
select 
	month_year
,	interest_name	
,	composition/index_value as Index_ComP
,	ROW_NUMBER() over( partition by month_year order by composition/index_value desc) as Ranking
from e8.interest_metrics as a
full join e8.interest_map as b
on a.interest_id=b.id
where month_year is not null
)
select *
from cte_a
where ranking<11

--2. For all of these top 10 interests - which interest appears the most often?

with cte_a as (
select 
	month_year
,	interest_name	
,	composition/index_value as Index_ComP
,	ROW_NUMBER() over( partition by month_year order by composition/index_value desc) as Ranking
from e8.interest_metrics as a
full join e8.interest_map as b
on a.interest_id=b.id
where month_year is not null
)
,	interests as (
select *
from cte_a
where ranking<11)

select
	interest_name
,	count(*) as Record_Count
from interests
group by interest_name
order by Record_Count desc

--3. What is the average of the average composition for the top 10 interests for each month?


with cte_a as (
select 
	month_year
,	interest_name	
,	composition/index_value as Index_ComP
,	ROW_NUMBER() over( partition by month_year order by composition/index_value desc) as Ranking
from e8.interest_metrics as a
full join e8.interest_map as b
on a.interest_id=b.id
where month_year is not null
)

select
	month_year
,	format(avg(index_comp),'N2') as average_comp
from cte_a
where ranking<11
group by month_year

