{{ config(materialized='view') }}

WITH cdm_batch_ctrlid AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_V2', 'CDM_BATCH_CTRLID') }}
)
SELECT
    *
FROM cdm_batch_ctrlid