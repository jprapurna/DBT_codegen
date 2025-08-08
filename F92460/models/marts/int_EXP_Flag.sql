-- Purpose: Set flags and timestamps based on lookup results
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  IIF(ISNULL(lkp_ROW_WID), 'I', IIF(MD5(BUR) = MD5(lkp_NEW_BUR), 'NC', 'U')) AS o_Flag, 
  SYSDATE AS CDM_INSERT_DT, 
  SYSDATE AS CDM_UPDATE_DT, 
  'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM 
  {{ ref('int_EXP_BUR') }}
LEFT JOIN 
  {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }} ON INTEGRATION_ID = lkp_INTEGRATION_ID