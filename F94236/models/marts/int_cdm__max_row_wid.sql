{{
  config(materialized='ephemeral')
}}

WITH lookup_data AS (
  SELECT 
    ROW_WID, 
    TABLE_NAME
  FROM {{ mplt_lkp_max_row_wid('TGT_TABLE_NAME') }}
)

SELECT * 
FROM lookup_data