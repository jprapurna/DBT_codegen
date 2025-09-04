{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),

cdm_batch_ctrlid AS (
  SELECT 
    {{ macro_status_running(SOURCE_NAME) }}
  FROM source_data
),

final AS (
  SELECT *
  FROM cdm_batch_ctrlid
)

SELECT * FROM final