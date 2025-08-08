-- Purpose: Process batch ID using mapplet
WITH mapplet_data AS (
    SELECT 
        IIF(ISNULL(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS o_BATCH_ID 
    FROM 
        {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
    o_BATCH_ID 
FROM 
    mapplet_data