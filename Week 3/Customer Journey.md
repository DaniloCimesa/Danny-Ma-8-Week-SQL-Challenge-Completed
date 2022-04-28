--Preparing data for customer_ids in a case study example. 
```
select 
customer_id
, p.plan_name
, start_date, datediff(day,lag(start_date) over (partition by customer_id order by start_date) ,start_date) as daydiff
, start_date, datediff(month,lag(start_date) over (partition by customer_id order by start_date) ,start_date) as monthdiff
from subscriptions s
join plans p
on s.plan_id=p.plan_id
where customer_id in (1,2,13,15,16,18,19)
```


![Capture1](https://user-images.githubusercontent.com/102156507/165506308-6199e8a7-542f-40a4-8e8e-edee49df6c2e.PNG)

Customer with ID=1 after one week of trial period started a basic monthly subscription.

Customer with ID=2 after one week of trial period started a pro annual subscription.

Customer with ID=13 after one week of trial period started a basic monthly subscription and 3 months later started a pro monthly subscription.

Customer with ID=15 after one week of trial period started a pro monthly subscription and 1 month later canceled subscription.

Customer with ID=16 after one week of trial period started a basic monthly subscription and 4 months later started a pro annual subcription.

Customer with ID=18 after one week of trial period started a pro monthly subscription.

Customer with ID=19 after one week of trial period started a pro monthly subscription and 2 months later started a pro annual subcription.
