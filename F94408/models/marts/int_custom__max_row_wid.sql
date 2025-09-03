{{
  config(materialized='ephemeral')
}}

WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    'TGT_TABLE_NAME' AS TABLE_NAME
  FROM {{ source('custom_table', 'max_row_wid') }}
  WHERE TABLE_NAME = 'TGT_TABLE_NAME'
),

exp_row_wid AS (
  SELECT 
    CASE 
      WHEN ROW_WID = 0 THEN ROW_WID + 1
      ELSE ROW_WID
    END AS ROW_WID
  FROM lkp_max_row_wid
)

SELECT ROW_WID
FROM exp_row_wid