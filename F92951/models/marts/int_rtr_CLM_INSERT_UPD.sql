-- Purpose: Route data to INSERT or UPDATE paths based on flag value
WITH routed_data AS (
  SELECT 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT, 
    TGT_TABLE_NAME 
  FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
  o_Flag, 
  CDM_INSERT_DT, 
  CDM_UPDATE_DT, 
  TGT_TABLE_NAME 
FROM routed_data