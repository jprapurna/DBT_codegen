-- Purpose: Process batch ID using mapplet
SELECT 
    o_BATCH_ID 
FROM 
    {{ ref('int_CDM_BATCH_CTRLID') }}