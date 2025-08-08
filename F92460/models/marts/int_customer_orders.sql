{{ config(materialized='table') }}

WITH customer_orders AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        CASE 
            WHEN order_status = 'Completed' THEN 'Success'
            ELSE 'Pending'
        END AS order_status
    FROM {{ source('sales', 'orders') }}
    WHERE order_date > {{ var('start_date') }}
)

SELECT * FROM customer_orders;