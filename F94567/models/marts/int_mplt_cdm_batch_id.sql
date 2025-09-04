{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_cdm_batch_ctrlid') }}
),

mplt_cdm_batch_id AS (
  SELECT 
    BATCH_ID
  FROM source_data
),

final AS (
  SELECT *
  FROM mplt_cdm_batch_id
)

SELECT * FROM final