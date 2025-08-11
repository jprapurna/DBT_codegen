-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME
WITH row_wid_data AS (
  SELECT 
    TGT_TABLE_NAME, 
    -- Assuming mapplet logic exists here
    'ROW_WID' AS row_wid
  FROM {{ ref('int_lkp_MAX_ROW_WID') }}
)
SELECT 
  TGT_TABLE_NAME, 
  row_wid
FROM row_wid_data