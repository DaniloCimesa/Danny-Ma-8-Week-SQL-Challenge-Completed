
--1.How many unique transactions were there?
select count(distinct txn_id)
from [E7].[sales]

--2. What is the average unique products purchased in each transaction?

with agg_data as (
select 
	txn_id
,   count(distinct prod_id) as Product_per_tran
from e7.sales
group by txn_id
)
select 
	avg(product_per_tran) as Average_N_ofProducts_PerTran
from agg_data

--3.What are the 25th, 50th and 75th percentile values for the revenue per transaction?
with temp as
(select txn_id, suM(qty * price) as transaction_revenue from e7.sales group by txn_id)
, percentiles as (
select percentile_cont (0.25) within group (order by transaction_revenue) over() as revenue_25percentile,
       percentile_cont (0.50) within group (order by transaction_revenue) over() as revenue_50percentile,
	   percentile_cont (0.75) within group (order by transaction_revenue) over() as revenue_75percentile

from temp)
select 
	max(revenue_25percentile) as [25thPercentile]	
,	max(revenue_50percentile) as Median
,	max(revenue_75percentile) as [75thPercentile]	
from percentiles

--4.What is the average discount value per transaction?

with T as (
select 
	txn_id
,	sum	(qty*b.price*a.discount*0.01) as Revenue_after_Discount
from e7.sales as a
full join [E7].[product_prices] as b
on a.prod_id=b.product_id
full join [E7].[product_details] as c
on a.prod_id=c.product_id
group by txn_id

)

select 
	avg(revenue_after_discount) as AVG_DISC_PERTRAN
from T
--4.What is the percentage split of all transactions for members vs non-members?

select
	case when member='T' then 'YES' else 'NO' end as Member	
,	format(count(distinct txn_id)*1.00/(select count(distinct txn_id) from e7.sales),'P2') as [Percent]
from e7.sales
group by member


--5.What is the average revenue for member transactions and non-member transactions?

with cte_a as (
select
	case when member='T' then 'YES' else 'NO' end as Member	
,	sum(qty*price) as Sum
,	count(distinct txn_id) as Num
from e7.sales
group by member
)

select
	member
,	sum*1.00/num as Avg_Tran_Revenue
from cte_a
