

--1. What day of the week is used for each week_date value? 

SELECT 
    *
,   DATENAME (weekday, WEEK_DATE) as WeekDay_Name
FROM clean_weekly_sales
ORDER BY Week_Number ASC

--2. What range of week numbers are missing from the dataset?

WITH CTE_A AS (
    SELECT 1 as N
UNION ALL
SELECT N+1 
   FROM CTE_A
WHERE N<52)

SELECT
  DISTINCT (A.N) 
FROM CTE_A A
FULL OUTER JOIN clean_weekly_sales B 
ON A.N=B.Week_Number
WHERE A.N NOT IN(SELECT Week_Number FROM clean_weekly_sales)

--ORDER BY N ASC

--3. How many total transactions were there for each year in the dataset?

SELECT
    DISTINCT (YEAR (Week_date)) AS Year
,   COUNT(transactions) AS CountOfTran
,   SUM (transactions) AS SumOFTran
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
, COUNT(transactions) AS TranCount
, SUM(transactions) AS SumCount
FROM clean_weekly_sales
GROUP BY platform


--6. What is the percentage of sales for Retail vs Shopify for each month?

WITH TotalSale AS(

SELECT
  calendar_year
, Month_Number
, platform
, SUM(CONVERT (BIGINT, sales)) AS TOTAL
FROM clean_weekly_sales
GROUP BY calendar_year, Month_Number, platform)

SELECT
    Calendar_year
,   Month_Number
--, FORMAT (CASE WHEN Platform='Retail' THEN TOTAL 1.00/TOTAL ELSE NULL END, 'P2') AS RetailPercentage
--, FORMAT(CASE WHEN Platform='Shopify' THEN TOTAL*1.00/TOTAL ELSE NULL END, 'P2') AS ShopifyPercentage
,   FORMAT (MAX(CASE WHEN platform= 'Retail' THEN TOTAL ELSE NULL END)* 1.00 / SUM(TOTAL), 'P2') AS RetailPercentage
,   FORMAT (MAX(CASE WHEN platform= 'Shopify' THEN TOTAL ELSE NULL END)* 1.00 / SUM(TOTAL), 'P2' AS ShopifyPercentage
FROM TotalSale
GROUP BY calendar_year, Month_number
ORDER BY calendar_year ASC, MONTH_number ASC
            
--7. What is the percentage of sales by demographic for each year in the dataset?
           
WITH SalesByDEM AS (
SELECT
   DISTINCT (YEAR (week_date)) AS Year 
,  SUM(CONVERT (BIGINT, sales)) AS SUM
,  demographic
FROM clean weekly sales 
GROUP BY YEAR(week_date), demographic
)
SELECT
      Year
--, demographic
,     FORMAT (MAX((CASE WHEN demographic='unknown' THEN SUM ELSE NULL END)*1.00)/ SUM(SUM), 'P2') AS Unknwn 
,     FORMAT (MAX((CASE WHEN demographic='Couples' THEN SUM ELSE NULL END)*1.00)/ SUM(SUM), 'P2') AS Couples 
,     FORMAT (MAX((CASE WHEN demographic='Families' THEN SUM ELSE NULL END)*1.00)/SUM(SUM), 'P2') AS Families

FROM SalesByDEm
GROUP BY Year
ORDER BY Year ASC
            
--8. Which age_band and demographic values contribute the most to Retail sales?

SELECT

   Age_band
,  demographic
,  SUM(CONVERT(BIGINT, sales)) AS Retail_sales
,  FORMAT(SUM(CONVERT(BIGINT, sales))* 1.00 / (SELECT SUM(CONVERT (BIGINT, sales)) FROM clean_weekly_sales WHERE platform='Retail'), 'P2') AS Percentage
FROM clean_weekly_sales 
WHERE platform='Retail'
GROUP BY Age_band, demographic
ORDER BY Retail_sales DESC
            
--9. Can we use the avg transaction column to find the average transaction size for each year for Retail vs Shopify? 
--If not how would you calculate it instead?

SELECT
   calendar_year
,  FORMAT (AVG(CONVERT(DECIMAL(5,2), AVG_transactions)), 'NO') AS AVGT
,  SUM (CONVERT (BIGINT, SALES))/ SUM(transactions) AS AVGG
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year ASC
            
