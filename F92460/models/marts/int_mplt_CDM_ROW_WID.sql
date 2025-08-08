-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME
SELECT 
  TGT_TABLE_NAME, 
  (SELECT NVL(MAX(ROW_WID), 0) + 1 FROM {{ ref('int_lkp_MAX_ROW_WID') }} WHERE TABLE_NAME = TGT_TABLE_NAME) AS ROW_WID
FROM 
  {{ ref('int_rtr_CLM_INSERT_UPD') }}
WHERE 
  o_Flag = 'I'