{{ config(materialized='view') }}

WITH cdm_batch_ctrlid AS (
    SELECT
        * -- No columns provided in source.yml
    FROM {{ source('CDM_BATCH_CTRLID', 'CDM_BATCH_CTRLID') }}
)
SELECT
    * -- No columns provided in source.yml
FROM cdm_batch_ctrlid