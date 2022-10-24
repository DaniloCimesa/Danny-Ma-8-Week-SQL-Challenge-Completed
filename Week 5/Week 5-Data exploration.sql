

--1. What day of the week is used for each week_date value? 

SELECT 
    *
,   DATENAME (weekday, WEEK_DATE)
FROM clean_weekly_sales
ORDER BY Week_Number ASC
'''
--2. What range of week numbers are missing from the dataset?

WITH CTE_A AS (
    SELECT 1 as N
UNION ALL
SELECT N+1 FROM CTE A
WHERE N<52)

SELECT
  DISTINCT (A.N) 
FROM CTE_A A
FULL OUTER JOIN clean weekly sales B 
ON A.N=B Week Number
WHERE A.N NOT IN(SELECT Week Number FROM clean_weekly sales)

--ORDER BY N ASC

--3. How many total transactions were there for each year in the dataset?

SELECT
    DISTINCT (YEAR (Week_date)) AS Year
,   COUNT(transactions) AS CountOfTran
,   SUM(transactions) AS SumOFTran
FROM clean_weekly_sales
GROUP BY YEAR (week_date)
ORDER BY Year ASC


--4. What is the total sales for each region for each month?

SELECT
    region
,   Month_Number
,   SUM(CONVERT (BIGINT, sales)) AS TOTAL 
FROM clean_weekly_sales
GROUP BY region, Month_Number
ORDER BY region, Month_Number

--5.What is the total count of transactions for each platform?

SELECT

  platform
, COUNT (transactions) AS TranCount
, SUM(transactions AS SumCount
FROM clean_weekly_sales
GROUP BY platform

WITH TotalSale AS(

SELECT
  calendar year
, Month Number
, platform
, SUM(CONVERT (BIGINT, sales)) AS TOTAL
FROM clean weekly sales
GROUP BY calendar year, Month Number, platform)

--6. What is the percentage of sales for Retail vs Shopify for each month?

SELECT
    Calendar year
,   Month Number
--, FORMAT (CASE WHEN Platform='Retail' THEN TOTAL 1.00/TOTAL ELSE NULL END, 'P2') AS RetailPercentage
--, FORMAT(CASE WHEN Platform='Shopify' THEN TOTAL*1.00/TOTAL ELSE NULL END, 'P2') AS ShopifyPercentage
,   FORMAT (MAX(CASE WHEN platform= 'Retail' THEN TOTAL ELSE NULL END)* 1.00 / SUM(TOTAL), 'P2') AS RetailPercentage
,   FORMAT (MAX(CASE WHEN platform= 'Shopify' THEN TOTAL ELSE NULL END)* 1.00 / SUM(TOTAL), 'P2' AS ShopifyPercentage
FROM TotalSale
GROUP BY calendar_year, Month_number
ORDER BY calendar_year ASC, MONTH number ASC
