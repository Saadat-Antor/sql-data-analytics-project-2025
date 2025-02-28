/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- determining 5 products produced the highest revenue
-- simple way
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex and flexible way
SELECT *
FROM (
SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;


-- determining 5 products produced the lowest revenue
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- determining 5 subcategories produced the highest revenue
SELECT TOP 5
p.sub_category,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.sub_category
ORDER BY total_revenue DESC;


-- determining 5 subcategories produced the lowest revenue
SELECT TOP 5
p.sub_category,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.sub_category
ORDER BY total_revenue

-- determining 10 customers who generated highest revenue
SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- determining 3 customers who ordered lowest
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders;
