

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

--4.What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 
--and include the previous top ranking interests in the same output shown below.
	
with cte_a 
as
(

select 
	Convert(date, _year+'-'+_month+'-01') as month_year
,	interest_name	
,	composition/index_value as Index_ComP
,	ROW_NUMBER() over( partition by month_year order by composition/index_value desc) as Ranking
from e8.interest_metrics as a
full join e8.interest_map as b
on a.interest_id=b.id
where month_year is not null
)
, prepare_cte as (
select	
	month_year	
,	interest_name
,	format(Index_ComP,'N2') as IndexMax
,	AVG(index_comp) OVER (ORDER BY month_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)AS moving_average
,	format(lag(index_comp, 1) over(order by month_year asc),'N2') as Lag1
,	lag(interest_name,1 ) over (order by month_year asc) LagName1
,	format(lag(index_comp, 2) over(order by month_year asc),'N2') as Lag2
,	lag(interest_name,2 ) over (order by month_year asc) LagName2
from cte_a
where ranking=1
--order by month_year asc
)
select 
	month_year
,	interest_name
,	IndexMax
,	format(moving_average,'N2') as [3_Moving_average]
,	lagname1+' :'+convert(varchar(4), lag1) as [1_MonthAgo]
,	lagname2+' :'+convert(varchar(4), lag2) as [2_MonthAgo]
from prepare_cte
where month_year between '2018-09-01' and '2019-08-01'
