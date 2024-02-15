

```
1. How many unique nodes are there on the Data Bank system?

SELECT COUNT(DISTINCT node_id) AS [Unique node count]
FROM customer_nodes

2. What is the number of nodes per region?

SELECT 
  region_name
, COUNT(node_id) AS Node_Count
FROM customer_nodes c
JOIN regions r
ON c.region_id=r.region_id
GROUP BY region_name

3. How many customers are allocated to each region?

SELECT 
  region_name
, COUNT(DISTINCT customer_id) AS Customers
FROM customer_nodes c
JOIN regions r
ON c.region_id=r.region_id
GROUP BY region_name

4. How many days on average are customers reallocated to a different node?

WITH cte AS (
SELECT 
*
,DATEDIFF(day, start_date, end_date) AS Diff
FROM customer_nodes
WHERE end_date != '9999-12-31' 

), cte_a AS (
SELECT 
  Customer_id
, Node_id
, SUM(Diff) AS Summ
FROM cte
GROUP By Customer_id, Node_id)

SELECT 
AVG(Summ)*1.0 AS AvgDate
FROM cte_a
```
```
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

with SourceTable as (
--creating source table with datediff between nodes
SELECT 
*
, DATEDIFF(day, start_date, end_date) AS DIFF
FROM e4.customer_nodes
WHERE end_date NOT LIKE '999%'
)	
, Percent_cte AS (
--adding percent rank of date difference and also ranking it by row number
SELECT 
 *  
, PERCENT_RANK () OVER (PARTITION BY region_id ORDER BY DIFF)*100 AS P
, row_number () over (PARTITION BY region_id ORDER BY DIFF) as OrderOfRows
FROM SourceTable) 
, median_source as (
--source for calculating median, n/2 and (n/2)+1 member of the chain
select
	region_id
,	ceiling((count(*)*1.00/100)*50) as First_MemberOfMedian
from SourceTable as A
group by A.region_id
union all
select
	region_id
,	ceiling((count(*)*1.00/100)*50)+1 as Second_MemberOfMedian
from SourceTable as A
group by A.region_id
)
,	median as (
--calculating median
select 
	a.region_id
,	sum(diff)/2 as Median
,	'P50' as P50
from median_source as A
inner join percent_cte as B
on A.First_MemberOfMedian=B.OrderOfRows and A.region_id=B.region_id
group by a.region_id
)
, Percentiles as (
--percentiles are calculated by dividing number of members of dataset by 100 and multiplying it by the desired percentile
--example 70th percentile if you have 200 rows is (200/100)*70 is equal to 140 which is your 70th percentile or the number which is larger than 70% percent of your chain
select
	region_id
,	ceiling((count(*)*1.00/100)*80) as Coll
,	'P80' as P80
from SourceTable as A
group by A.region_id
union all
select
	region_id
,	ceiling((count(*)*1.00/100)*95) as Coll
,	'P95' as P95
from SourceTable as A
group by A.region_id

)
Select 
	A.region_id
,	max(case when P50='P50' then Median end) [Median]
,	max(case when P80 ='P80' then Diff end) [80thPercentile]
,	max(case when P80 ='P95' then Diff end) [95thPercentile]

from Percentiles as A
inner join percent_cte as B
on A.Coll=B.OrderOfRows and A.region_id=B.region_id
inner join median as C
on C.region_id=A.region_id
group by a.region_id--, t2.p80
order by region_id asc

--That was my way, and there is a new PERCENTILE_CONT function in version 2022 which is suitable for counting percentiles

with cte_source as (
SELECT 
*
, DATEDIFF(day, start_date, end_date) AS DIFF
FROM e4.customer_nodes
WHERE end_date NOT LIKE '999%')

select 
	 distinct region_id
,	  percentile_cont(0.5) within group(order by diff) over (partition by region_id) as percentile_cont_5
,	  percentile_cont(0.8) within group(order by diff) over (partition by region_id) as percentile_cont_8
,	  percentile_cont(0.95) within group(order by diff) over (partition by region_id) as percentile_cont_95
from cte_source


