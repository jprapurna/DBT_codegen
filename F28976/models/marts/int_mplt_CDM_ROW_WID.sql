-- Purpose: Mapplet transformation for generating ROW_WID
WITH row_wid_data AS (
  SELECT 
    TGT_TABLE_NAME, 
    ROW_WID 
  FROM {{ ref('int_lkp_MAX_ROW_WID') }}
)
SELECT 
  TGT_TABLE_NAME, 
  ROW_WID 
FROM row_wid_data