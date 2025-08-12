-- Purpose: Process batch ID using mapplet
WITH mapplet_data AS (
    SELECT 
        CASE 
            WHEN ISNULL(batch_id) THEN MAX(batch_id) 
            ELSE batch_id 
        END AS o_batch_id
    FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
    o_batch_id
FROM mapplet_data