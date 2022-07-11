
```
1.What is the unique count and total amount for each transaction type?

SELECT 
	txn_type
,	COUNT(txn_type) AS CountOfT
,	SUM(txn_amount) AS SumOfT
FROM customer_transactions
GROUP BY txn_type

2.What is the average total historical deposit counts and amounts for all customers?

WITH CTE_a AS (
SELECT 
	customer_id
,	COUNT(customer_id) AS CountPerC
,	AVG(txn_amount)*1.00 AS SUMperC
FROM customer_transactions
WHERE txn_type='deposit'
GROUP BY customer_id
)
SELECT 
	AVG(CountPerC) as C
,	AVG(SUMperC) as S
FROM CTE_a


3.For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

WITH CTE_a AS ( 

SELECT 
   customer_id, 
   MONTH(txn_date) AS month1,
   SUM (CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
   SUM (CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_count,
   SUM (CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
FROM customer_transactions
GROUP BY customer_id, month(txn_date)
)

SELECT 
	month1
,	COUNT(DISTINCT customer_id) as MonthlyCount
FROM CTE_a 
WHERE deposit_count>1 AND (purchase_count=1 OR withdrawal_count=1)
GROUP BY month1  

4. What is the closing balance for each customer at the end of the month?

WITH CTE_A AS (
SELECT 
	customer_id
,	MONTH(txn_date) AS Month
,	EOMONTH(txn_date) AS EoMonth
,	CASE WHEN txn_type='deposit' THEN txn_amount
								 ELSE -txn_amount END AS Balance
FROM customer_transactions
)
, CTE_B AS (
SELECT 
	Customer_id
,	Month
,   EoMonth
,	SUM(Balance) AS MonthlyChange
FROM CTE_A
GROUP BY Month, Customer_id, EOMONTH)

SELECT 
	Customer_id
,	Month
,	EOMONTH
,	MonthlyChange
,	SUM(MonthlyChange) OVER (PARTITION BY customer_id ORDER BY Month) AS MonthEndBalance	 
FROM CTE_B
GROUP BY Customer_id, Month, EOMONTH, MonthlyChange
ORDER BY customer_id ASC


5. What is the percentage of customers who increase their closing balance by more than 5%?

WITH CTE_A AS (
SELECT 
	customer_id
,	MONTH(txn_date) AS Month
,	EOMONTH(txn_date) AS EoMonth
,	CASE WHEN txn_type='deposit' THEN txn_amount
								 ELSE -txn_amount END AS Balance
FROM customer_transactions
)
, CTE_B AS (
SELECT 
	Customer_id
,	Month
,   EoMonth
,	SUM(Balance) AS MonthlyChange
FROM CTE_A
GROUP BY Month, Customer_id, EOMONTH)
, CTE_C AS (
SELECT 
	Customer_id
,	Month
,	EOMONTH
,	MonthlyChange
,	SUM(MonthlyChange) OVER (PARTITION BY customer_id ORDER BY Month) AS MonthEndBalance	 
FROM CTE_B
GROUP BY Customer_id, Month, EOMONTH, MonthlyChange
)
, CTE_D AS (
SELECT 
	*
,	Convert(decimal(10,2),ISNULL(LAG(MonthEndBalance) OVER (PARTITION BY customer_id ORDER BY Month ASC),MonthEndBalance)) AS PreviousMonth
FROM CTE_C
WHERE MonthEndBalance>0 )

/*SELECT 
	customer_id
, COUNT(CASE WHEN	MonthEndBalance/PreviousMonth>=1.05 THEN '1' ELSE 0 END) AS TEST
FROM CTE_D
GROUP BY customer_id*/
, CTE_E AS (
SELECT 
	*
,	CASE WHEN	MonthEndBalance/PreviousMonth>=1.05 THEN '1' ELSE 0 END AS TEST
FROM CTE_D)

SELECT 
TOP 1(SELECT COUNT(DISTINCT customer_id) FROM CTE_E WHERE TEST>0)*1.00/ (SELECT COUNT(DISTINCT Customer_id) FROM customer_transactions) AS Percentage
FROM CTE_E
```
