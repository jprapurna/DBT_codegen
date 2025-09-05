{{ config(materialized='view') }}

WITH new_bur_table AS (
    SELECT
        "NEW_BUR" AS new_bur -- New burden data
    FROM {{ source('CDH_GW_BUR', 'NEW_BUR') }}
)
SELECT
    new_bur
FROM new_bur_table