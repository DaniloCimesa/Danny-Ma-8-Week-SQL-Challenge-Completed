

	select 	
	d.product_id
,	d.price
,	a.level_text+' '+b.level_text+' - '+c.level_text as product_name
,	b.parent_id as category_id
,	a.parent_id as segment_id
,	a.id as style_id
,	c.level_text as category_name
,	b.level_text as segment_name
,	a.level_text as style_name
into e7.prod_details1	
from [E7].[product_hierarchy] as A
full join [E7].[product_hierarchy] as B
on a.parent_id=B.id
full join [E7].[product_hierarchy] as C
on b.parent_id=c.id
full join [E7].[product_prices] as D
on a.id=d.id
where c.level_text is not null and b.level_text is not null and a.level_text is not null
