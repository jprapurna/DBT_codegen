-- Purpose: Fetch max batch id for incoming source name.

SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'lkp_CDM_BATCH_CTRLID') }}
WHERE STATUS = 'RUNNING'
GROUP BY SOURCE_NAME