{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        "lkp_CDM_BATCH_CTRLID" AS lkp_cdm_batch_ctrlid -- Table identifier
    FROM {{ source('CDH_GWODS_CDM', 'lkp_CDM_BATCH_CTRLID') }}
)
SELECT
    lkp_cdm_batch_ctrlid
FROM lkp_cdm_batch_ctrlid