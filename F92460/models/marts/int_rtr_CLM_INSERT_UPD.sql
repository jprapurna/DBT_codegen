-- Purpose: Route data based on 'o_Flag'
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  o_Flag, 
  CASE 
    WHEN o_Flag = 'I' THEN SYSDATE 
    ELSE NULL 
  END AS CDM_INSERT_DT, 
  CASE 
    WHEN o_Flag = 'U' THEN SYSDATE 
    ELSE NULL 
  END AS CDM_UPDATE_DT, 
  CASE 
    WHEN o_Flag = 'I' THEN 'W_CLAIM_CD_BUR_SCD3_I' 
    ELSE 'W_CLAIM_CD_BUR_SCD3_U' 
  END AS TGT_TABLE_NAME
FROM 
  {{ ref('int_EXP_Flag') }}