-- Purpose: Check for null values in BATCH_ID
WITH null_check_data AS (
    SELECT 
        CASE 
            WHEN ISNULL(lkp_batch_id) THEN -999 
            ELSE lkp_batch_id 
        END AS o_batch_id
    FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
    o_batch_id
FROM null_check_data