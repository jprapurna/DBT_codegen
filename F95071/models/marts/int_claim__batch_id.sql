{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),

lookup_step AS (
  SELECT
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM source_data
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
),

null_check_step AS (
  SELECT
    *,
    {{ mplt_batch_id('BATCH_ID') }} AS o_BATCH_ID
  FROM lookup_step
)

SELECT *
FROM null_check_step