{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),
exp_NULL_CHECK AS (
  SELECT
    *,
    {{ isnull('batch_ctrlid', 0) }} AS batch_ctrlid_checked
  FROM source_data
)
SELECT * FROM exp_NULL_CHECK