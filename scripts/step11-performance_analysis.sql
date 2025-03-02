/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- segmenting products into cost ranges and count how many products fall under each segments
WITH products_cost_ranges AS(
SELECT
product_id,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END AS cost_range
FROM gold.dim_products
)
SELECT
cost_range,
COUNT(product_id) AS product_count
FROM products_cost_ranges
GROUP BY cost_range
ORDER BY product_count DESC;

-- segmenting the customers into three parts and count number of customers in each segments
WITH customer_segments_table AS (
SELECT
c.customer_key,
SUM(s.sales_amount) AS total_spent,
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS customer_lifespan
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
customer_segments,
COUNT(customer_key) AS total_customers
FROM(
SELECT
customer_key,
CASE WHEN DATEDIFF(MONTH, first_order_date, last_order_date) >= 12 AND total_spent > 5000 THEN 'VIP'
	 WHEN DATEDIFF(MONTH, first_order_date, last_order_date) >= 12 AND total_spent < 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segments
FROM customer_segments_table
) t
GROUP BY customer_segments
ORDER BY total_customers DESC;
