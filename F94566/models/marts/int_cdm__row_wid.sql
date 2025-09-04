{{
  config(materialized='ephemeral')
}}

WITH exp_row_wid AS (
  SELECT 
    ROW_WID, 
    TABLE_NAME
  FROM {{ mplt_CDM_ROW_WID('TGT_TABLE_NAME') }}
)

SELECT * FROM exp_row_wid