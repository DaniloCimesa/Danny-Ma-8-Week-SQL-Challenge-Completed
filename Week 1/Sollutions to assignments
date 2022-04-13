

--1.What is the total amount each customer spent at the restaurant?

select customer_id, sum(price) as [Total Amount Spent]
from sales s
join menu m
on s.product_id=m.product_id
group by customer_id

--2.How many days has each customer visited the restaurant?

select customer_id, count(order_date) as [Days visited]
from sales
group by customer_id

--3.What was the first item from the menu purchased by each customer? 

select customer_id, product_name
from sales s
join menu m
on s.product_id=m.product_id
where order_date in (select min(order_date) from sales group by customer_id)


--4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select top 1 product_name, count(s.product_id) as [Most Purchases]
from sales s
join menu m
on s.product_id=m.product_id
group by product_name
order by [Most Purchases] desc

-- 5. Which item was the most popular for each customer?

with cte_a as (
select s.customer_id, product_name, count(s.product_id) as countProd, 
rank () over (partition by s.customer_id order by count(s.product_id) desc) as Rank,
dense_rank () over (partition by s.customer_id order by count(s.product_id) desc) as DRank
from sales s
join menu m
on s.product_id=m.product_id
group by s.customer_id, product_name)

select customer_id as Customer, product_name
from cte_a
where Rank=1

--6.Which item was purchased first by the customer after they became a member?

with cte_a as (
select s.customer_id,product_name, order_date, join_date, s.product_id, 
DENSE_RANK() over (partition by s.customer_id order by order_date) as dr
from sales s
join menu m
on s.product_id=m.product_id
join members me
on me.customer_id=s.customer_id
where order_date>=join_date
)

select * 
from cte_a
where dr=1

--7.Which item was purchased just before the customer became a member?

with cte_a as (
select s.customer_id, order_date, product_name, join_date, DENSE_RANK() over (partition by s.customer_id order by order_date) as rank
from sales s
join menu m
on s.product_id=m.product_id
join members me
on me.customer_id=s.customer_id
where order_date<=join_date
)

select customer_id, product_name
from cte_a
where rank=1

--8.What is the total items and amount spent for each member before they became a member?

select s.customer_id, count(s.product_id) as countOrders, sum(price) as MoneySpent
from sales s
join menu m
on s.product_id=m.product_id
join members me
on s.customer_id=me.customer_id
where order_date<join_date
group by s.customer_id

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


with cte_a as (
select *,
case when product_id=(select product_id from menu where product_name='sushi') then price*20 else price*10 end as Points
from menu )

select s.customer_id, sum(points)
from sales s
join cte_a 
on s.product_id=cte_a.product_id
group by s.customer_id

--My way
with cte_a as (

select customer_id, case when product_name='sushi' then price*20 else price*10 end as Points
from sales s
join menu m
on s.product_id=m.product_id
)
select customer_id, sum(points) as Points
from cte_a
group by customer_id

--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
--not just sushi - how many points do customer A and B have at the end of January?

with cte_a as (

select  customer_id,join_date,dateadd(day, 6,join_date) as FreeWeek, '2021-01-31' as MonthEnd
from members)

Select s.customer_id, sum( case when product_name='sushi' then price*20 
               when order_date between join_date and FreeWeek then price*20
			   else price*10 end)
from sales s
join cte_a 
on s.customer_id=cte_a.customer_id
join menu m
on s.product_id=m.product_id
where order_date<Monthend and s.customer_id!='C'
group by s.customer_id

--Bonus questions 

with cte_a as (
select s.customer_id, order_date, product_name, price,
case when order_date<join_date then 'N' 
     when s.customer_id='C' then 'N'
else 'Y' end as member
from sales s
join menu m
on s.product_id=m.product_id
join members me
on s.customer_id=me.customer_id
)
select *, case when member='N' then null else 
rank () over (partition by customer_id, member order by order_date)
end as ranking
from cte_a
