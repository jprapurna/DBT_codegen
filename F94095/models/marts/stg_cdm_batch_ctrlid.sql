-- Purpose: Staging model for CDM_BATCH_CTRLID lookup table
WITH batch_data AS (
    SELECT 
        MAX(BATCH_ID) AS BATCH_ID,
        TRIM(SOURCE_NAME) AS SOURCE_NAME
    FROM {{ source('genai_power_bi', 'lkp_cdm_batch_ctrlid') }}
    WHERE STATUS = {{ ref('status_running') }}
    GROUP BY SOURCE_NAME
)
SELECT * FROM batch_data