-- Purpose: Check for null values in BATCH_ID
WITH null_check_data AS (
    SELECT 
        BATCH_ID, 
        SOURCE_NAME, 
        IIF(IsNull(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS o_BATCH_ID 
    FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
    BATCH_ID, 
    SOURCE_NAME, 
    o_BATCH_ID 
FROM null_check_data