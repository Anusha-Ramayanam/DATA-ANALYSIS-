USE pizza;
SELECT * FROM pizza_sales;
DESC pizza_sales;

UPDATE pizza_sales
SET order_date=str_to_date(order_date,"%d-%m-%Y");

ALTER TABLE pizza_sales
MODIFY order_date date;

-- TOTAL REVENUE
SELECT SUM(total_price) total_revenue FROM pizza_sales;

-- AVERAGE ORDER VALUE
SELECT (SUM(total_price)/COUNT(DISTINCT order_id)) avg_order_value
from pizza_sales;

-- TOTAL PIZZAS SOLD
SELECT SUM(quantity) total_pizzas_sold FROM pizza_sales;

-- TOTAL ORDERS
SELECT COUNT(DISTINCT order_id) total_orders FROM pizza_sales;

-- AVERAGE PIZZAS PER ORDER
SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id),2) avg_pizzas_per_order from pizza_sales;

-- DAY TREND FOR TOTAL ORDERS
SELECT DAYNAME(order_date) day, COUNT(DISTINCT order_id) total_orders from pizza_sales
GROUP BY DAYNAME(order_date);

-- MONTHLY TREND FOR TOTAL ORDERS
SELECT MONTHNAME(order_date) month, COUNT(DISTINCT order_id) total_orders from pizza_sales
GROUP BY MONTHNAME(order_date);

-- PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT pizza_category,ROUND(SUM(total_price),2) total_sales,
ROUND(100* SUM(total_price)/ (SELECT SUM(total_price) FROM pizza_sales),2) PCT from pizza_sales
GROUP BY pizza_category;

-- -- PERCENTAGE OF SALES BY PIZZA SIZE
SELECT pizza_size,ROUND(SUM(total_price),2) total_sales,
ROUND(100* SUM(total_price)/ (SELECT SUM(total_price) FROM pizza_sales),2) PCT from pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- TOTAL PIZZAS SOLD BY PIZZA CATEGORY
SELECT pizza_category, SUM(quantity)total_pizzas_sold from pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold desc;

-- TOP 5 PIZZAS BY REVENUE
SELECT pizza_name,
SUM(total_price) total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue desc
LIMIT 5;

-- BOTTOM 5 PIZZAS BY REVENUE
SELECT pizza_name,
ROUND(SUM(total_price),2) total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue
LIMIT 5;

-- TOP 5 PIZZAS BY QUANTITY
SELECT pizza_name,
SUM(quantity) total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity desc
LIMIT 5;

-- BOTTOM 5 PIZZAS BY QUANTITY
SELECT pizza_name,
SUM(quantity) total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity
LIMIT 5;

-- BOTTOM 5 PIZZAS BY TOTAL ORDERS
SELECT pizza_name,
COUNT(DISTINCT order_id) total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders
LIMIT 5;

-- TOP 5 PIZZAS BY TOTAL ORDERS
SELECT pizza_name,
COUNT(DISTINCT order_id) total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders desc
LIMIT 5;






