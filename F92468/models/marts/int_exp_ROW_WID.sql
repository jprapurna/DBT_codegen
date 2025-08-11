-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_calculation AS (
  SELECT 
    TGT_TABLE_NAME, 
    IIF(v2 = 0, lookup(), v2) AS row_wid
  FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
  TGT_TABLE_NAME, 
  row_wid
FROM row_wid_calculation