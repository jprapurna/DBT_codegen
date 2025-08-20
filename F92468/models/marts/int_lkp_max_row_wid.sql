-- Purpose: Represents the lookup transformation fetching maximum ROW_WID from the target table

WITH max_row_data AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS row_wid,
    $$TGT_TABLE_NAME AS table_name
  FROM {{ source('GENAI_POWER_BI', 'LKP_MAX_ROW_WID') }}
  WHERE TABLE_NAME = $$TGT_TABLE_NAME
)

SELECT 
  row_wid,
  table_name
FROM max_row_data