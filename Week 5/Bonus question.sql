--Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

--Region
DECLARE @WEEKNUM INT
SET @WEEKNUM = (
SELECT
  DISTINCT Week_Number
 FROM clean_weekly_sales
 WHERE WEEK_DATE='2020-06-15')
 
  SELECT
    region  
,   SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS B4Sales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) AS AFTRSales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) 
  -SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS Variance
,   FORMAT( (SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END)*1.00
          - SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END))/
          SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END), 'P2') AS PERCENTAGE
FROM clean_weekly_sales
WHERE calendar_year=2020
GROUP BY region
ORDER BY Percentage

--Platform
DECLARE @WEEKNUM INT
SET @WEEKNUM = (
SELECT
  DISTINCT Week_Number
 FROM clean_weekly_sales
 WHERE WEEK_DATE='2020-06-15')
 
  SELECT
    platform  
,   SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS B4Sales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) AS AFTRSales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) 
  -SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS Variance
,   FORMAT( (SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END)*1.00
          - SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END))/
          SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END), 'P2') AS PERCENTAGE
FROM clean_weekly_sales
WHERE calendar_year=2020
GROUP BY platform
ORDER BY Percentage

--Age_band
DECLARE @WEEKNUM INT
SET @WEEKNUM = (
SELECT
  DISTINCT Week_Number
 FROM clean_weekly_sales
 WHERE WEEK_DATE='2020-06-15')
 
  SELECT
    age_band 
,   SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS B4Sales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) AS AFTRSales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) 
  -SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS Variance
,   FORMAT( (SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END)*1.00
          - SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END))/
          SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END), 'P2') AS PERCENTAGE
FROM clean_weekly_sales
WHERE calendar_year=2020
GROUP BY age_band
ORDER BY Percentage


--Demographic
DECLARE @WEEKNUM INT
SET @WEEKNUM = (
SELECT
  DISTINCT Week_Number
 FROM clean_weekly_sales
 WHERE WEEK_DATE='2020-06-15')
 
  SELECT
    demographic  
,   SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS B4Sales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) AS AFTRSales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) 
  -SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS Variance
,   FORMAT( (SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END)*1.00
          - SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END))/
          SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END), 'P2') AS PERCENTAGE
FROM clean_weekly_sales
WHERE calendar_year=2020
GROUP BY demographic
ORDER BY Percentage

--customer_type
DECLARE @WEEKNUM INT
SET @WEEKNUM = (
SELECT
  DISTINCT Week_Number
 FROM clean_weekly_sales
 WHERE WEEK_DATE='2020-06-15')
 
  SELECT
    customer_type  
,   SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS B4Sales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) AS AFTRSales
,   SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END) 
  -SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END) AS Variance
,   FORMAT( (SUM(CASE WHEN Week_Number < DATEADD(DAY, +12,@Week_Number) AND Week_Number >= @Week_Number THEN CONVERT (BIGINT, SALES) END)*1.00
          - SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END))/
          SUM(CASE WHEN Week_Number >=DATEADD(DAY, -12,@Week_Number) AND Week_Number < @Week_Number THEN CONVERT (BIGINT, SALES) END), 'P2') AS PERCENTAGE
FROM clean_weekly_sales
WHERE calendar_year=2020
GROUP BY customer_type
ORDER BY Percentage
