/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
    - LEFT JOIN
===============================================================================
*/

-- determining total customers by country
SELECT
country,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- determining total customers by gender
SELECT
gender,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- determining total customers by marital status
SELECT
marital_status,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY total_customers DESC;

-- determining total products by category
SELECT
category,
COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- determining total products by category and sub category
SELECT
category,
sub_category,
COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY category, sub_category
ORDER BY total_products DESC;

-- determining average costs in each category
SELECT
category,
AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- determining average costs in each category and subcategory
SELECT
category,
sub_category,
AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category, sub_category
ORDER BY avg_cost DESC;

-- determining total revenue generated for each category
SELECT
p.category,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- determining total revenue generated for each customer
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- determining the distribution of sold items accross countries
SELECT
c.country,
SUM(quantity) AS items_sold
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY items_sold DESC;
