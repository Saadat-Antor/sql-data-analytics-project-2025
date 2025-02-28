
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- exploring all the countries where are our customers from
SELECT DISTINCT country FROM gold.dim_customers;

-- exploring all the categories, sub_category, product_name of products
SELECT DISTINCT category, sub_category, product_name FROM gold.dim_products
ORDER BY 1,2,3;
