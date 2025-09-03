{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
)

SELECT *
FROM source_data