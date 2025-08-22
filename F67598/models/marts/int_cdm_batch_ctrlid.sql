-- Purpose: Retrieves the maximum batch ID and trims the source name from the table CDM.CDM_BATCH_CTRLID.
WITH source_data AS (
    SELECT 
        MAX(batch_id) AS batch_id,
        LTRIM(RTRIM(source_name)) AS source_name
    FROM {{ source('genai_power_bi', 'lkp_cdm_batch_ctrlid') }}
    GROUP BY source_name
)
SELECT * FROM source_data