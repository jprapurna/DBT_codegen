{{
  config(materialized='ephemeral')
}}

WITH null_check AS (
  SELECT 
    {{ macro_null_check('batch_id') }} AS batch_id_checked
  FROM {{ ref('int_cdm__batch_ctrlid_lookup') }}
)

SELECT *
FROM null_check