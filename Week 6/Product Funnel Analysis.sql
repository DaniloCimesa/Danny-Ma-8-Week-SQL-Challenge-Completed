

/*Using a single SQL query - create a new output table which has the following details:

- How many times was each product viewed?
- How many times was each product added to cart?
- How many times was each product added to a cart but not purchased (abandoned)?
- How many times was each product purchased?*/

WITH CTE_A AS (

SELECT
    page_name
,   product_category
,   SUM(CASE WHEN E.event_type=1 THEN 1 ELSE 0 END) AS PView
,   SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) AS [Add to Cart]
,   ROW_NUMBER() OVER (ORDER BY page_name ASC) AS [Order]
FROM events E
FULL JOIN event_identifier EI
ON E.event_type=EI.event_type 
FULL JOIN page_hierarchy P
ON  E.page_id=P.page_id
WHERE P.product_id IS NOT NULL
GROUP BY page_name, product_category
)

, CTE_B AS (

SELECT
    page_name
,   SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) AS [Ab Purch]
,   ROW_NUMBER() OVER (ORDER BY page_name ASC) AS [Order]
FROM events E
FULL JOIN event_identifier EI
ON E.event_type=EI.event_type 
FULL JOIN page_hierarchy P
ON  E.page_id=P.page_id
WHERE visit_id NOT IN (SELECT visit_id FROM events WHERE event_type=3)
GROUP BY P.page_name
HAVING SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) >0
)

, CTE_C AS (

SELECT
    A.Page_name
,   product_category
,   PView AS [Page View]
,   [Add to Cart]
,   [Ab Purch] AS [Abandoned Purchases]
,   [Add to Cart] - [Ab Purch] AS Purchases
FROM CTE_A A
JOIN CTE_B B
ON A.[ORDER]=B.[ORDER]
)

/*SELECT *
FROM CTE_C
ORDER BY product_category ASC*/


--Additionally, create another table which further aggregates the data for the above points but this time
--for each product category instead of individual products.


, CTE_D AS (

SELECT
    DISTINCT product_category
,   SUM(PView) AS [Page View]
,   SUM([Add to Cart]) AS [Add to Cart]
,   SUM([Ab Purch]) AS [Abandoned Purchases]
,   SUM([Add to Cart]) - SUM([Ab Purch]) AS Purchases
FROM CTE_A A
JOIN CTE_B B
ON A.[ORDER]=B.[ORDER]
GROUP BY product_category)
--SELECT *
--FROM CTE_D


--3. Which product had the highest view to purchase percentage?

/*
SELECT 
    TOP 1 page_name
,   MAX(FORMAT(Purchases*1.00/[Page View], 'P2')) AS Percentage
FROM CTE_C
GROUP BY page_name
ORDER BY Percentage DESC*/

--4.What is the average conversion rate from view to cart add?
--5.What is the average conversion rate from cart add to purchase?

SELECT 
    FORMAT(AVG([Add to Cart]*1.00/[Page View]), 'P2') AS ADTC_PV_CONV
,   FORMAT(AVG([Purchases]*1.00/[Add to Cart]), 'P2') AS ADTC_PC_CONV
FROM CTE_C






