{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    *
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),

exp_null_check AS (
  SELECT 
    *,
    CASE 
      WHEN {{ isnull('COLUMN_NAME', 'DEFAULT_VALUE') }} THEN 'NULL'
      ELSE COLUMN_NAME
    END AS checked_column
  FROM source_data
)

SELECT * FROM exp_null_check