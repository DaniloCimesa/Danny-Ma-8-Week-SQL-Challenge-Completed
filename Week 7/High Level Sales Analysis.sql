--1.What was the total quantity sold for all products?
select sum(qty) as total_sales
from e7.sales 

--this is the way to get product sales by each product
select 
	b.product_name
,	sum(qty) as sold
from e7.sales as a
full join e7.product_details as b
on a.prod_id=b.product_id
group by b.product_name

--2.What is the total generated revenue for all products before discounts?

select 
sum	(qty*b.price) as Revenue_B4_Discount
from e7.sales as a
full join [E7].[product_prices] as b
on a.prod_id=b.product_id

--revenue per product
select 
	c.product_name
,	sum	(qty*b.price) as Revenue_B4_Discount
from e7.sales as a
full join [E7].[product_prices] as b
on a.prod_id=b.product_id
full join [E7].[product_details] as c
on a.prod_id=c.product_id
group by c.product_name

--3.What was the total discount amount for all products?

select 
	sum	(qty*b.price*a.discount*0.01) as Revenue_after_Discount
from e7.sales as a
full join [E7].[product_prices] as b
on a.prod_id=b.product_id

--discount per product
select 
	c.product_name
,	sum	(qty*b.price*a.discount*0.01) as Revenue_after_Discount
from e7.sales as a
full join [E7].[product_prices] as b
on a.prod_id=b.product_id
full join [E7].[product_details] as c
on a.prod_id=c.product_id
group by c.product_name
