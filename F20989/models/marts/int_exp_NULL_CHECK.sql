-- Purpose: Check for null values in BATCH_ID
SELECT 
    IIF(ISNULL(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS o_BATCH_ID 
FROM {{ ref('int_CDM_BATCH_CTRLID') }}