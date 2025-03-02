/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT
s.customer_key,
s.order_date,
s.order_number,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name,
p.category,
p.sub_category,
p.cost
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
)
, product_segregation AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
product_key,
product_name,
category,
sub_category,
cost,
COUNT(order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS product_lifespan_months,
CASE WHEN SUM(sales_amount) > 50000 THEN 'High-Performers'
	 WHEN SUM(sales_amount) >= 10000 THEN 'Mid-Performers'
	 ELSE 'Low-Performers'
END AS product_segments
FROM base_query
GROUP BY product_key, product_name, category, sub_category, cost
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
product_name,
category,
sub_category,
cost,
total_orders,
total_quantity,
total_customers,
product_lifespan_months,
product_segments,
total_sales,
DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_months,
CASE WHEN total_orders = 0 THEN 0
	 ELSE total_sales/total_orders
END AS avg_order_revenue,
CASE WHEN product_lifespan_months = 0 THEN total_sales
	 ELSE total_sales/product_lifespan_months
END AS avg_monthly_revenue
FROM product_segregation;
