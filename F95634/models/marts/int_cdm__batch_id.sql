{{ config(materialized='ephemeral') }}

WITH batch_ctrlid_data AS (
  SELECT * 
  FROM {{ ref('int_cdm__batch_ctrlid') }}
),

batch_id_logic AS (
  SELECT
    *,
    {{ macro_md5('BATCH_ID') }} AS hashed_batch_id
  FROM batch_ctrlid_data
)

SELECT * FROM batch_id_logic