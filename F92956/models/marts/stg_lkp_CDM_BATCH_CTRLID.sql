{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name
"BATCH_ID" AS batch_id -- Batch ID
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'lkp_CDM_BATCH_CTRLID') }}