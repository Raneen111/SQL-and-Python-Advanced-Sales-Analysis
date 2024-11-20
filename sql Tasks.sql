
--1
--top selling products in general :
SELECT order_items.product_id, COUNT(orders.order_id) AS total_sales
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY product_id
ORDER BY total_sales DESC;

--top selling products in region :
SELECT order_items.product_id, COUNT(orders.order_id) AS total_sales,customer_state
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
join customers on customers.customer_id=customers.customer_id
GROUP BY product_id,customer_state
ORDER BY total_sales DESC; 


--2
-- Most popular categoried
SELECT product_category_name, COUNT(orders.order_id) AS category_sales
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
GROUP BY product_category_name
ORDER BY category_sales DESC;

--3
-- Monthly Sales
select 
MONTH (order_purchase_timestamp) as Sale_mounth,
year (order_purchase_timestamp) as Sale_year, 
sum (price) As Total_Sales
from orders
join order_items on orders.order_id = order_items.order_id
Group By month(order_purchase_timestamp),YEAR(order_purchase_timestamp)
order by YEAR(order_purchase_timestamp), Sale_mounth ;

-- Quarterly Sales
select 
DATEPART (quarter, order_purchase_timestamp) as Sale_quarter ,
year (order_purchase_timestamp) as Sale_year, 
sum (price) As Total_Sales
from orders
join order_items on orders.order_id = order_items.order_id
Group By Datepart(QUARTER,order_purchase_timestamp),YEAR(order_purchase_timestamp)
order by YEAR(order_purchase_timestamp),Sale_quarter ;

--Yearly Sales
select 
year (order_purchase_timestamp) as Sale_year, 
sum (price) As Total_Sales
from orders
join order_items on orders.order_id = order_items.order_id
Group By YEAR(order_purchase_timestamp)
order by YEAR(order_purchase_timestamp);



--4 
--Average sale by product category
SELECT product_category_name,avg(price) AS Average_sales
FROM products
join order_items ON products.product_id = order_items.product_id
GROUP BY product_category_name
ORDER BY Average_sales DESC;


--Top product categories by customer location
--Top product categories based on order count, and in which Customer State are they located
SELECT product_category_name, customer_state, COUNT(orders.order_id) AS order_count
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON order_items.product_id = products.product_id
GROUP BY product_category_name, customer_state
ORDER BY order_count DESC;

--Top Product Categories by order count for each Customer State
WITH ranked_sales AS (
    SELECT 
        customer_state, 
        product_category_name, 
        COUNT(orders.order_id) AS order_count ,
        ROW_NUMBER() OVER (PARTITION BY customer_state ORDER BY COUNT(orders.order_id) DESC) AS rank
    FROM orders
	JOIN order_items ON orders.order_id = order_items.order_id
    JOIN customers ON orders.customer_id = customers.customer_id
    JOIN products ON order_items.product_id = products.product_id
    GROUP BY customer_state, product_category_name
)
SELECT customer_state, product_category_name,order_count 
FROM ranked_sales
WHERE rank = 1;


