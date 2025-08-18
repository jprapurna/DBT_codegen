-- Purpose: Lookup transformation to fetch maximum `ROW_WID` from the target table

WITH max_row_data AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    $$TGT_TABLE_NAME AS TABLE_NAME
  FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}
  WHERE TABLE_NAME = IN_TABLE_NAME
)

SELECT 
  ROW_WID,
  TABLE_NAME
FROM max_row_data