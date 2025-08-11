-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME.
WITH mplt_cdm_row_wid AS (
  SELECT 
    TGT_TABLE_NAME,
    -- Variable binding for ROW_WID, assuming some logic here
    ROW_WID
  FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
  TGT_TABLE_NAME,
  ROW_WID
FROM mplt_cdm_row_wid