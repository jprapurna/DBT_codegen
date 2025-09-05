{{
  config(materialized='ephemeral')
}}

WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS max_row_wid
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
),

incremented_row_wid AS (
  SELECT 
    {{ increment_v1('max_row_wid') }} AS new_row_wid
  FROM max_row_wid
)

SELECT 
  new_row_wid AS ROW_WID
FROM incremented_row_wid