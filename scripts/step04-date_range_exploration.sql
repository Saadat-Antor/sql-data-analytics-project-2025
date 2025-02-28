/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- finding the first and last order from sales
SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years, -- order dates range in years
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_months -- order dates range in months
FROM gold.fact_sales;

-- finding the oldest and youngest customers' birthadte and age
SELECT
MIN(birthday) AS oldest_customer_birthdate,
DATEDIFF(year, MIN(birthday), GETDATE()) AS oldest_customer_age,
MAX(birthday) AS youngest_customer_birthdate,
DATEDIFF(year, MAX(birthday), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;
