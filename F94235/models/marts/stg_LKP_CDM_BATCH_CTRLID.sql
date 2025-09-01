{{ config(materialized='view') }}

SELECT
    SOURCE_NAME AS source_name,  -- Source name column
    BATCH_ID AS batch_id,        -- Batch ID column
    STATUS AS status             -- Status column
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_CDM_BATCH_CTRLID') }}