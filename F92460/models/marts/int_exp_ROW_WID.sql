-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    INTEGRATION_ID, 
    ROW_WID, 
    IIF(V2 = 0, (SELECT NVL(MAX(ROW_WID), 0) FROM {{ ref('int_lkp_MAX_ROW_WID') }}), V2) AS V1, 
    V1 + 1 AS V2
  FROM 
    {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  V2 AS ROW_WID
FROM 
  row_wid_data