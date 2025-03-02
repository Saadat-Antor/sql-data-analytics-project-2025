/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS(
  /*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT
s.order_number,
s.product_key,
order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(year, c.birthday, GETDATE()) AS customer_age
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
)
, customer_segregation AS(
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT
customer_key,
customer_number,
customer_name,
customer_age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_products,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS customer_lifespan_months
FROM base_query
GROUP BY customer_key, customer_number, customer_name, customer_age
)
SELECT
customer_key,
customer_number,
customer_name,
customer_age,
CASE WHEN customer_age < 20 THEN 'Under 20'
	 WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
	 WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
	 WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
	 ELSE 'Above 50'
END AS age_groups,
CASE WHEN customer_lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN customer_lifespan_months >= 12 AND total_sales < 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segments,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
customer_lifespan_months,
CASE WHEN customer_lifespan_months = 0 THEN total_sales
	 ELSE total_sales / customer_lifespan_months
END AS avg_monthly_spent,
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales/total_orders
END AS avg_order_value
FROM customer_segregation;
