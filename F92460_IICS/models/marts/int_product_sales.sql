{{ config(materialized='table') }}

WITH product_sales AS (
    SELECT 
        product_id,
        SUM(sales_amount) AS total_sales,
        COUNT(order_id) AS total_orders
    FROM {{ source('sales', 'order_items') }}
    WHERE sales_date BETWEEN {{ var('start_date') }} AND {{ var('end_date') }}
    GROUP BY product_id
)

SELECT * FROM product_sales;