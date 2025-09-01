{{ config(materialized='ephemeral') }}

WITH exp_row_wid AS (
  SELECT 
    ROW_WID
  FROM {{ mplt_CDM_ROW_WID('TARGET_TABLE_NAME') }}
)

SELECT *
FROM exp_row_wid