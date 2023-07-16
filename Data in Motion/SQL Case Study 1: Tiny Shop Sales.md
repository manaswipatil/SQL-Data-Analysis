# Tiny Shop Sales
![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/7803c73a-be0d-461a-acc3-c0b4dcf92f57)
<hr>

### Questions & Solutions
<b> 1. Which product has the highest price? Only return a single row. </b>

~~~sql
 **Query #1**

    SELECT product_id, product_name, price
    FROM products
    WHERE price = ( SELECT max(price) FROM products )
    ;
---
**Query #2**

    SELECT product_id, product_name, price
    FROM products
    ORDER BY price DESC
    LIMIT 1
    ;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/8ecb49fb-c0f4-405b-8c93-d84cdd22c427)

<b> 2. Which customer has made the most orders? </b>

~~~sql
with most_order_cte as (
SELECT C.customer_id, COUNT(O.order_id) AS no_of_orders, CONCAT(C.first_name, ' ', C.last_name) AS Customer_Name
	,RANK() OVER(order by COUNT(O.order_id) desc) AS ranks
FROM orders O
JOIN customers C ON O.customer_id = C.customer_id
GROUP BY C.customer_id, C.first_name, C.last_name
)

select customer_id, Customer_Name, no_of_orders
from most_order_cte
where ranks = 1
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/bdf467bc-3981-4c72-9da5-940e732e271f)

<b> 3. What’s the total revenue per product? </b>

~~~sql
select o.product_id, p.product_name, SUM(p.price*o.quantity) as Total_Revenue
from products p
inner join order_items o on o.product_id = p.product_id
group by o.product_id, p.product_name
order by Total_Revenue desc
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/95ef0d29-21e6-49e5-844b-320dcaa6576b)

<b> 4. Find the day with the highest revenue. </b>

~~~sql
select top 1
	o.order_date,
	SUM(p.price*oi.quantity) as Total_Revenue
from products p
inner join order_items oi on oi.product_id = p.product_id
inner join orders o on oi.order_id = o.order_id 
group by o.order_date
order by Total_Revenue desc
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/41da18d2-fefc-43dc-8cdd-866ee77e278b)

<b> 5. Find the first order (by date) for each customer. </b>

~~~sql
select c.customer_id, concat(c.first_name, ' ', c.last_name) as Customer_name, min(o.order_date) as first_order_date
from orders o
inner join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/219cb42f-0e13-49ac-94f5-3af10567b4eb)

<b> 6. Find the top 3 customers who have ordered the most distinct products </b>

~~~sql
select top 3 c.customer_id, concat(c.first_name, ' ', c.last_name) as Customer_name, COUNT(distinct oi.product_id) as distinct_products
from order_items oi
inner join orders o on oi.order_id = o.order_id
inner join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/4dbc0c7d-504a-4b00-9970-0cdb319f5054)

<b> 7. Which product has been bought the least in terms of quantity? </b>

~~~sql
with least_bought as (
select p.product_name, SUM(quantity) as buy_frequency
	,RANK() over(order by SUM(quantity) asc) as ranks
 from order_items oi
 join products p on oi.product_id = p.product_id
 group by p.product_name
 )

 Select product_name
 from least_bought
 where ranks = 1
 ;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/26645674-1e73-40e9-8467-f9e2f2d12da2)

<b> 8. What is the median order total? </b>

~~~sql
** Query 1 **
with order_total_cte as (
select
	SUM(p.price*oi.quantity) as Total_Revenue
	,ROW_NUMBER() over (order by SUM(p.price*oi.quantity) asc) as rownum_asc
	,ROW_NUMBER() over (order by SUM(p.price*oi.quantity) desc) as rownum_desc
from products p
inner join order_items oi on oi.product_id = p.product_id
group by oi.order_id
)

select AVG(Total_Revenue) as median 
from order_total_cte
where ABS(rownum_asc - rownum_desc) <= 1
;

**Query 2**
select top 1 median 
 from (
select order_id,
	SUM(p.price*oi.quantity) as Total_Revenue
	,PERCENTILE_CONT(0.5) within group (order by SUM(p.price*oi.quantity)) over() as median
from products p
inner join order_items oi on oi.product_id = p.product_id
group by oi.order_id
) m
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/a02cbe07-5736-450d-8259-9d23125ec591)


<b> 9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’. </b>

~~~sql
select order_id,
	SUM(p.price*oi.quantity) as Total_Revenue
	,case when SUM(p.price*oi.quantity) > 300 Then 'Expensive'
		when SUM(p.price*oi.quantity) > 100 Then 'Affordable'
		else 'Cheap'
		end as category
from products p
inner join order_items oi on oi.product_id = p.product_id
group by oi.order_id
;

~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/fa5a1289-c651-4f6e-91c8-85e715ad3ebe)

<b> 10. Find customers who have ordered the product with the highest price. </b>

~~~sql
select CONCAT(c.first_name, ' ', c.last_name) as customer_name
from order_items oi 
inner join orders o on oi.order_id = o.order_id
inner join customers c on o.customer_id = c.customer_id
where product_id = (
select top 1 product_id
from products
order by price desc
)
;
~~~~

![image](https://github.com/manaswipatil/SQL-Data-Analysis/assets/50437663/2d6079a6-628a-4d1a-b283-6bb4ff6a2ab9)



