                   ----Sales Project---
----Get all customers from Consumer segment----
SELECT *
FROM coustomers
WHERE segment = 'Consumer';

----Find all products in Furniture category----
SELECT *
FROM products
WHERE category = 'Furniture';

---Show orders shipped using Second Class----
SELECT *
FROM orders
WHERE ship_mode = 'Second Class';

--Find products with discount greater than 0---
SELECT *
FROM order_details
WHERE discount > 0;

----Get orders placed after 2016---
SELECT *
FROM orders
WHERE order_date > '2016-01-01';

---Get customer name with order id---
select * from coustomers
SELECT c.customer_name, o.order_id
FROM coustomers c
JOIN orders o
ON c.customer_id = o.customer_id;

---Show product name with sales---
SELECT p.product_name, od.sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id;

----Orders with customer name and ship mode----
SELECT c.customer_name, o.ship_mode
FROM coustomers c
JOIN orders o
ON c.customer_id = o.customer_id;

---Get city and sales---
SELECT l.city, od.sales
FROM location l
JOIN order_details od
ON l.postal_code = od.postal_code;

---Product category with total sales---
SELECT p.category, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.category;

----Total sales by category----
SELECT p.category, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.category;

---Total profit by region----
SELECT l.region, SUM(CAST(od.profit AS FLOAT)) AS total_profit
FROM location l
JOIN order_details od
ON l.postal_code = od.postal_code
GROUP BY l.region;

---Highest selling category----
SELECT p.category, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_sales DESC

---Top 10 products by sales---
SELECT Top 10 p.product_name, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC

---Customers who never placed orders---
SELECT c.customer_name
FROM coustomers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

---Orders with negative profit---
SELECT *
FROM order_details
WHERE CAST(profit AS DECIMAL(10,4)) < 0;

---Most profitable region---
SELECT l.region, SUM(CAST(od.profit AS DECIMAL(10,4))) AS total_profit
FROM location l
JOIN order_details od
ON l.postal_code = od.postal_code
GROUP BY l.region
ORDER BY total_profit DESC;

---Top selling sub category---
SELECT p.sub_category, SUM(od.sales) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.sub_category
ORDER BY total_sales DESC;

---2nd highest sales product---
SELECT p.product_name, SUM(CAST(od.sales AS DECIMAL(10,2))) AS total_sales
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY ;

---Running total of sales---
SELECT order_id,
SUM(sales) OVER (ORDER BY order_id) AS running_total
FROM order_details;

---Monthly sales--
SELECT 
MONTH(order_date) AS month,
SUM(od.sales) AS total_sales
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY MONTH(order_date);

----Region wise top customer----
SELECT region, customer_name, total_sales
FROM (
SELECT l.region,
c.customer_name,
SUM(od.sales) AS total_sales,
RANK() OVER(PARTITION BY l.region ORDER BY SUM(od.sales) DESC) rnk
FROM cOustomers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN location l ON od.postal_code = l.postal_code
GROUP BY l.region, c.customer_name
) t
WHERE rnk = 1;

---Category highest profit---
SELECT  p.category, SUM(CAST(od.profit AS DECIMAL (10,4)))total_profit
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_profit DESC;
