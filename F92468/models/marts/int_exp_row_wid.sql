-- Purpose: Calculate `ROW_WID` using variables and lookup

WITH row_wid_data AS (
  SELECT 
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME,
    IIF(v2=0, :LKP.lkp_MAX_ROW_WID(TGT_TABLE_NAME), V2) AS V1,
    V1 + 1 AS V2,
    V2 AS ROW_WID
  FROM {{ ref('int_lkp_max_row_wid') }}
)

SELECT 
  TGT_TABLE_NAME,
  ROW_WID
FROM row_wid_data