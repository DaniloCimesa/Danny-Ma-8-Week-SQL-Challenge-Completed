

SELECT 
    DISTINCT user_id
,   MIN(event_time) AS DateEarly
,   SUM(CASE WHEN E.event_type=1 THEN 1 ELSE 0 END) AS PageViews
,   SUM(CASE WHEN E.event_type=2 THEN 1 ELSE 0 END) AS CartAdd
,   SUM(CASE WHEN E.event_type=3 THEN 1 ELSE 0 END) AS Purchase
,   campaign_name
,   SUM(CASE WHEN E.event_type=4 THEN 1 ELSE 0 END) AS Impression
,   SUM(CASE WHEN E.event_type=5 THEN 1 ELSE 0 END) AS AdClick
,   STRING_AGG(CASE WHEN p.product_id IS NOT NULL AND E.event_type=2 THEN page_name ELSE '' END, ', ') AS B
FROM users U
JOIN events E
ON U.cookie_id=E.cookie_id
JOIN event_identifier EI
ON E.event_type=EI.event_type
JOIN campaign_identifier CI
ON event_time BETWEEN CI.start_date AND CI.end_date
JOIN page_hierarchy P
ON E.page_id=P.page_id
GROUP BY user_id, visit_id, campagin_name
ORDER BY user_id, visit_id
    
