

--Step 1. 
--Creating a temporary table to change and adapt date column from dataset.

SELECT

LEFT(REPLACE(week_date, LEFT(week_date, CHARINDEX('/', week_date)), ''),2)

 + CASE WHEN LEFT(week_date,2) NOT LIKE '%'/ THEN LEFT(week_date,2)+'/'
                                             ELSE LEFT(week_date, 2) END

+ CASE WHEN RIGHT (week_date, 2) ='18' THEN REPLACE(RIGHT (week_date,2), '18',
'2018')
       WHEN RIGHT (week_date, 2)='19' THEN REPLACE(RIGHT(week_date,2), '19', '2019')
                                      ELSE RIGHT (week_date, 2)+ '20' END AS WEEK_DATE
, region
, Platform
, CASE WHEN segment='null' THEN 'unknown' 
                          ELSE segment END AS Segment
, customer_type
, transactions
, sales
INTO #weekly_sales1
FROM weekly_sales

--Altering data column type to DATE.
ALTER TABLE #weekly_sales1 
ALTER COLUMN week_date DATE

--Step 3. Importing altered data to new permanent table, so when a SSMS is closed the table stays.
SELECT
*
, DATEPART(WK, week_date) AS Week_Number
, DATEPART(M, week_date) AS Month_Number 
, YEAR (week_date) AS calendar_year

, CASE WHEN segment LIKE '%1' THEN 'Young Adults' ELSE 'Retirees' END AS Age_band
       WHEN segment LIKE '%2' THEN 'Middle Aged'
       WHEN segment LIKE '%own THEN 'unknown'
                               ELSE 'Retirees' END AS Age_band
, CASE WHEN segment LIKE 'F%' THEN 'Families' 
       WHEN segment LIKE 'C%' THEN 'Couples'
                              ELSE 'unknown' END AS demographic
, FORMAT(Sales*1.00/transactions, 'N2') AS avg_transactions
INTO clean_weekly_sales 
FROM #weekly_sales1
