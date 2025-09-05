{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),
exp_ROW_WID AS (
  SELECT
    *,
    {{ increment_v1('ROW_WID') }} AS new_row_wid
  FROM source_data
)
SELECT * FROM exp_ROW_WID