{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    *
FROM lkp_cdm_batch_ctrlid