/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- Checking the sales_amount changed through each order year
SELECT
YEAR(order_date) AS order_year,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Checking the sales_amount changed through each order month
SELECT
MONTH(order_date) AS order_month,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

-- Checking the sales_amount changed through each order year and order month
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- using the first date of each month to show the trend
SELECT
DATETRUNC(month, order_date) AS order_date,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- using the first date of each year to show the trend
SELECT
DATETRUNC(year, order_date) AS order_date,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
ORDER BY DATETRUNC(year, order_date);

-- using the formatted date to show the trend
SELECT
FORMAT(order_date, 'yyyy-MMM') AS order_date,
SUM(quantity) AS total_quantity,
SUM(sales_amount) AS sales_by_date,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
