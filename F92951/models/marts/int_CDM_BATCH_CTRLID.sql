-- Purpose: Fetches max batch ID based on source name from CDM_BATCH_CTRLID.
WITH max_batch_ctrlid AS (
    SELECT 
        MAX(BATCH_ID) AS batch_id, 
        LTRIM(RTRIM(SOURCE_NAME)) AS source_name
    FROM 
        {{ source('IICS', 'lkp_CDM_BATCH_CTRLID') }}
    WHERE 
        STATUS = 'RUNNING'
    GROUP BY 
        SOURCE_NAME
)
SELECT 
    batch_id, 
    source_name
FROM 
    max_batch_ctrlid