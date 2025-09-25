{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),

exp_batch_ctrlid AS (
  SELECT
    SOURCE_NAME,
    BATCH_ID,
    STATUS,
    {{ macro_md5('SOURCE_NAME') }} AS SOURCE_NAME_HASH
  FROM source_data
)

SELECT * FROM exp_batch_ctrlid;