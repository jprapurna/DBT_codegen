{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('custom_table', 'max_row_wid') }}
),

lkp_max_row_wid AS (
  SELECT 
    ROW_WID, 
    TABLE_NAME
  FROM {{ macro_lkp_max_row_wid(IN_TABLE_NAME) }}
),

final AS (
  SELECT *
  FROM lkp_max_row_wid
)

SELECT * FROM final