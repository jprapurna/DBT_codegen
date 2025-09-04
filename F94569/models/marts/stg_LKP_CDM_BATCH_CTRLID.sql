{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('lkp_CDM_BATCH_CTRLID', 'lkp_CDM_BATCH_CTRLID') }}
)
SELECT
    * -- No columns specified in source.yml
FROM lkp_cdm_batch_ctrlid