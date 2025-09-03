{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        *
    FROM {{ source('CDH_GWODS', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    *
FROM lkp_cdm_batch_ctrlid