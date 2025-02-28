/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

WARNING:
    - You can either run the first half or the last half of the code, seperated below.
      They will show the same metrics. Otherwise your results window will be overpopulated.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- determining total sales made
SELECT 
SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- determining total number of items sold
SELECT 
SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- determining average selling price
SELECT 
AVG(price) AS avg_selling_price
FROM gold.fact_sales;

-- determining total number of orders
SELECT 
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- determining total number of products
SELECT
COUNT(product_id) AS total_products
FROM gold.dim_products;

-- determining total number of customers
SELECT
COUNT(customer_id) AS total_customers
FROM gold.dim_customers;

-- determining total number of customers who have ordered
SELECT
COUNT(DISTINCT customer_key) AS tot_customer_ordered
FROM gold.fact_sales;

-- ============================================================ CHOOSE EITHER FIRST HALF OR SECOND HALF: SHOWS THE SAME METRICS==========================================================================

-- getting all the key metrics together
SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Avg. price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total products', COUNT(product_id) FROM gold.dim_products
UNION ALL
SELECT 'Total customers', COUNT(customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Total customers who ordered', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
