--Create table of members
CREATE TABLE members (
  customer_id VARCHAR(1) primary key,
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09'),
  ('C', '2021-01-01');


--Create table for menu

create TABLE menu (
  product_id INTEGER identity (1,1),
  product_name VARCHAR(5),
  price INTEGER,
  constraint pk_id primary key (product_id)
);

set identity_insert menu on
INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
set identity_insert menu off  
--Creating third table for sales.
create TABLE sales (
  customer_id VARCHAR(1) ,
  order_date DATE,
  product_id INTEGER 
);
--Had to add constraint for customer_id to add it as foreign key. The same thing with product_id.
alter table sales
add constraint fk_customer_id
foreign key (customer_id) references members (customer_id)

alter table sales
add constraint fk_product_id
foreign key (product_id) references menu (product_id)

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
