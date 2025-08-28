SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
FROM {{ source('genai_power_bi', 'lkp_cdm_batch_ctrlid') }}
WHERE STATUS = 'RUNNING'
GROUP BY SOURCE_NAME