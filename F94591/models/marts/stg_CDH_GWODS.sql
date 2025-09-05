{{ config(materialized='view') }}

WITH cdh_gwods_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'CDH_GWODS') }}
)
SELECT
    *
FROM cdh_gwods_data