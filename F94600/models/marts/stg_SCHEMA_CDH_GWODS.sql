{{ config(materialized='view') }}

WITH schema_cdh_gwods_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'SCHEMA_CDH_GWODS') }}
)
SELECT
    *
FROM schema_cdh_gwods_data