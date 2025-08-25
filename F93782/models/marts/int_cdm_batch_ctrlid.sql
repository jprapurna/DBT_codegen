-- Purpose: Fetches max batch_id grouped by source_name from CDM_BATCH_CTRLID.
SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
FROM {{ schema_cdm() }}.CDM_BATCH_CTRLID
WHERE STATUS={{ status_running() }}
GROUP BY SOURCE_NAME