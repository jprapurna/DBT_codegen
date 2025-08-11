-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME
WITH row_wid_data AS (
  SELECT 
    ROW_WID 
  FROM {{ source('IICS', 'LKP_MAX_ROW_WID') }}
  WHERE TABLE_NAME = 'W_CLAIM_CD_BUR_SCD3'
)
SELECT 
  ROW_WID 
FROM row_wid_data