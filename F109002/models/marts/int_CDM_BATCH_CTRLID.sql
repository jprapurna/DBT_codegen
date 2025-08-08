-- Purpose: Fetch max batch ID based on source name
WITH batch_data AS (
    SELECT 
        MAX(BATCH_ID) AS BATCH_ID, 
        LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME 
    FROM {{ source('genai_power_bi', 'lkp_CDM_BATCH_CTRLID') }}
    WHERE STATUS = 'RUNNING'
    GROUP BY SOURCE_NAME
)
SELECT 
    BATCH_ID, 
    SOURCE_NAME 
FROM batch_data