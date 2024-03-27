

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
