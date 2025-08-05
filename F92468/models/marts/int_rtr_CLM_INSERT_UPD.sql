-- Purpose: Route data based on 'o_Flag'
WITH routed_data AS (
  SELECT 
    o_Flag, 
    CASE WHEN o_Flag = 'I' THEN 'I' ELSE 'U' END AS CDM_INSERT_DT, 
    CASE WHEN o_Flag = 'U' THEN 'U' ELSE NULL END AS CDM_UPDATE_DT, 
    CASE WHEN o_Flag = 'I' THEN 'I' ELSE 'U' END AS TGT_TABLE_NAME 
  FROM 
    {{ ref('int_EXP_Flag') }}
)
SELECT 
  o_Flag, 
  CDM_INSERT_DT, 
  CDM_UPDATE_DT, 
  TGT_TABLE_NAME 
FROM 
  routed_data