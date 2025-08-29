-- Purpose: Calculates ROW_WID using variables V1 and V2.
SELECT 
  TGT_TABLE_NAME,
  CASE 
    WHEN V2 = 0 THEN {{ ref('int_mplt_CDM_ROW_WID') }}.ROW_WID
    ELSE V2 + 1
  END AS ROW_WID
FROM {{ ref('int_mplt_CDM_ROW_WID') }}