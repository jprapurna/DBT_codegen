WITH batch_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('genai_power_bi', 'cdm_batch_ctrlid') }}
  WHERE STATUS = {{ var('STATUS_RUNNING') }}
  GROUP BY SOURCE_NAME
)
SELECT * FROM batch_data