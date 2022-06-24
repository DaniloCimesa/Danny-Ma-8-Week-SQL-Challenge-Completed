

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


5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

WITH cte_a AS (

SELECT 
*
, DATEDIFF(day, start_date, end_date) AS DIFF
FROM customer_nodes
WHERE end_date NOT LIKE '999%'
)

, Percent_cte AS (
SELECT 
 *  
, PERCENT_RANK () OVER (PARTITION BY region_id ORDER BY DIFF)*100 AS P
FROM cte_a 
)
, Median AS (
SELECT 
  region_id
, MIN(DIFF) AS MedianDays
FROM percent_cte
WHERE P>=50
GROUP BY region_id
),
EightyPercent AS (
SELECT 
  region_id
, MIN(DIFF) AS [80thPercentileDays]
FROM percent_cte
WHERE P>80
GROUP BY region_id)
, NinetyFifthPercent AS (

SELECT 
  region_id
, MIN(DIFF) AS [95thPercentileDays]
FROM percent_cte
WHERE P>95
GROUP BY region_id)

SELECT 
  region_name
, MedianDays
, [80thPercentileDays]
, [95thPercentileDays]
FROM Median M
JOIN EightyPercent E
ON M.region_id=E.region_id
JOIN NinetyFifthPercent N
ON M.region_id=N.region_id
JOIN regions r
ON M.region_id=r.region_id
```
