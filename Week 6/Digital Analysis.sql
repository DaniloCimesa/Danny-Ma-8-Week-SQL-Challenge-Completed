--1.How many users are there?

SELECT 
  COUNT(DISTINCT (user_id)) AS UserNum
FROm users

--2. How many cookies does each user have on average?

WITH CTE_A AS (
SELECT
  user_id
, COUNT(cookie_id) AS CCount
FROM users
GROUP BY user_id
)
SELECT 
  AVG(CCount*1.00) AS AVGCCount
FROM CTE_A

--3. What is the unique number of visits by all users per month?

SELECT
    DISTINCT MONTH(event_time) AS MONTH
,   COUNT(DISTINCT visit_id)   AS COUNT
FROM events
GROUP BY MONTH(event_time)
ORDER BY MONTH

--4. What is the number of events for each event type? 

SELECT
    DISTINCT event_name
,   COUNT(*) AS Count
FROM Events E
JOIN event_identifier EI
ON E.event_type=EI.event_type
GROUP BY event_name

--5. What is the percentage of visits which have a purchase event?

SELECT
    FORMAT(COUNT(DISTINCT E.visit_id)*1.00/(SELECT COUNT(DISTINCT visit_id) FROM events), 'P2') AS '%ofPurchase'
FROM events E
JOIN event_identifier EI
ON E.event_type=Ei.event_type
WHERE event_name='Purchase'

--6. What is the percentage of visits which view the checkout page but do not have a purchase event?

WITH CTE_A AS (

   SELECT
      visit_id
   ,  STRING_AGG(page_id,', ') AS ROW
   FROM events
   GROUP BY visit_id)
   
SELECT 
    FORMAT(COUNT(*)*1.00/(SELECT COUNT(*) FROM CTE_A WHERE Row LIKE '%13' OR Row LIKE '%12'), 'P2') AS Percentage
FROM CTE_A
WHERE Row LIKE '%12'

--7. What are the top 3 pages by number of views?

SELECT
     TOP 3 page_name
,    COUNT (E.page_id) AS COUNT
FROM events E
JOIN page_hierarchy PH
ON E.page_id=PH.page_id
GROUP BY page_name
ORDER BY COUNT DESC

--8. What is the number of views and cart adds for each product category?

SELECT
    product_category
,   SUM(CASE WHEN E.event_type=1 THEN 1 ELSE 0 END) AS 'View' 
,   SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) AS AddToCart
FROM events E
FULL JOIN page_hierarchy PH
ON E.page_id=PH.page_id
FULL JOIN event_identifier EI
ON E.event_type=EI.event_type
WHERE product_category IS NOT NULL
GROUP BY product_category
ORDER BY 'View' DESC

--9. What are top 3 products by purchase?


SELECT
    TOP 3 page_name
,   SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) AS Count
FROM events E
FULL JOIN page_hierarchy PH
ON E.page_id=PH.page_id
FULL JOIN event_identifier EI
ON E.event_type=EI.event_type
WHERE visit_id IN (
  SELECT
      visit_id
  FROM events E
    FULL JOIN page_hierarchy PH
        ON E.page_id=PH.page_id
    FULL JOIN event_identifier EI
        ON E.event_type=EI.event_type
  WHERE e.event_type=3
  GROUP BY visit_id)
GROUP BY page_name
HAVING SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) >0
ORDER BY COUNT DESC
  
