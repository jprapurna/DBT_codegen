{{ config(materialized='view') }}

WITH cdm_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'CDM') }}
)
SELECT
    *
FROM cdm_data