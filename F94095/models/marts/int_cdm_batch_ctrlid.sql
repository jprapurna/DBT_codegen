-- Purpose: Intermediate model for batch ID null check
WITH batch_data AS (
    SELECT 
        BATCH_ID,
        SOURCE_NAME,
        CASE 
            WHEN BATCH_ID IS NULL THEN -999
            ELSE BATCH_ID
        END AS o_BATCH_ID
    FROM {{ ref('stg_cdm_batch_ctrlid') }}
)
SELECT * FROM batch_data