-- Purpose: Check for null values in BATCH_ID
SELECT 
    BATCH_ID, 
    SOURCE_NAME, 
    IIF(ISNULL(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS o_batch_id
FROM {{ ref('int_CDM_BATCH_CTRLID') }}