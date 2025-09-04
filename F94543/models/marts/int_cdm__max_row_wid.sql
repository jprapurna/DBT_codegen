{{ config(materialized='ephemeral') }}

WITH max_row_wid AS (
  SELECT 
    ROW_WID,
    TABLE_NAME
  FROM {{ mplt_CDM_ROW_WID('target_table') }}
)

SELECT * 
FROM max_row_wid