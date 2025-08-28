-- Purpose: Staging model for CDM batch control ID.
WITH source_data AS (
    SELECT 
        MAX(BATCH_ID) AS BATCH_ID,
        TRIM(SOURCE_NAME) AS SOURCE_NAME
    FROM {{ source('CDM', 'lkp_CDM_BATCH_CTRLID') }}
    WHERE STATUS = 'RUNNING'
    GROUP BY SOURCE_NAME
)
SELECT * FROM source_data;