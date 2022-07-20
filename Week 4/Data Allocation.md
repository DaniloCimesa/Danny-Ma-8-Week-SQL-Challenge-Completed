
Creating a running balance that is affected after each customer transaction.

One way to do it is using a SUM() with an OVER clause.
```
WITH CTE_A AS (
SELECT 
	*
,	CASE WHEN txn_type='deposit' THEN txn_amount
				     ELSE -txn_amount END AS amountEdited

FROM customer_transactions
)

SELECT 
	customer_id
,	txn_date
,	txn_type
,	amountEdited
,	SUM(amountEdited) OVER (PARTITION BY customer_id ORDER BY txn_date) running_balance
FROM CTE_A
```
