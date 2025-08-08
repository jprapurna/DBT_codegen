-- Purpose: Process batch ID using mapplet
SELECT 
    SOURCE_NAME, 
    BATCH_ID AS o_BATCH_ID 
FROM {{ ref('int_CDM_BATCH_CTRLID') }}