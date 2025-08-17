{{ config(materialized='view') }}

SELECT
    "BATCH_ID" AS batch_id, -- Batch ID
    "SOURCE_NAME" AS source_name -- Source name for the batch
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'lkp_CDM_BATCH_CTRLID') }}