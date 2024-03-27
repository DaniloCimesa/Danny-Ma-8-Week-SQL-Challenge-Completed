

--1. What are the top 3 products by total revenue before discount?

select 
	top 3 product_name
,	sum(qty*a.price) as Rev
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=B.product_id
group by product_name
order by Rev desc

--2. What is the total quantity, revenue and discount for each segment?

select 
	 segment_name
,	sum(qty) as sum_qty
,	sum(qty*B.price) as rev
,	sum(qty*b.price*discount*0.01) as Disc
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by segment_name
order by sum_qty desc

--3.What is the top selling product for each segment?
with cte_a as (
select 
	segment_name
,	product_name
,	sum(qty) as sumSale
,	ROW_NUMBER() over(partition by segment_name order by sum(qty) desc) as RN
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by segment_name, product_name
)
select 
	segment_name
,	product_name
,	sumSale as NumberOfSales
from cte_a
where RN=1

--4. What is the total quantity, revenue and discount for each category?

select 
	category_name
,	sum(qty) as quantity
,	sum(qty*a.price) as Rev
,	sum(qty*b.price*discount*0.01) as Disc
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by category_name


--5. What is the top selling product for each category?


with cte_a as (
select 
	category_name
,	product_name
,	sum(qty) as sumSale
,	ROW_NUMBER() over(partition by category_name order by sum(qty) desc) as RN
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by category_name, product_name
)
select 
	category_name
,	product_name
,	sumSale as NumberOfSales
from cte_a
where RN=1


--6. What is the percentage split of revenue by product for each segment?


with cte_a as (
select 
	segment_name
,	product_name
,	sum(qty*b.price) as sumSale
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by segment_name, product_name
)
select 
	*
,format(SumSale*1.00/sum(sumsale) over(partition by segment_name),'P2') as sumAll
from cte_a

--7. What is the percentage split of revenue by segment for each category?


with cte_a as (
select 
	category_name
,	segment_name
,	sum(qty*b.price) as sumSale
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by category_name, segment_name
)
select 
	*
,format(SumSale*1.00/sum(sumsale) over(partition by category_name),'P2') as sumAll
from cte_a

--8. What is the percentage split of total revenue by category?

with cte_a as (
select 
	category_name
,	sum(qty*b.price) as sumSale
from [E7].[sales] as A
full join [E7].[product_details] as B
on A.prod_id=b.product_id
group by category_name
)
select 
	*
,format(SumSale*1.00/(select sum(sumsale) from cte_a),'P2') as sumAll
from cte_a

