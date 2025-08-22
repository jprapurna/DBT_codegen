-- Purpose: Calculates flags, timestamps, and target table name.
SELECT 
  INTEGRATION_ID, 
  SOURCE_NAME, 
  o_BATCH_ID, 
  LKP_ROW_WID, 
  LKP_INTEGRATION_ID, 
  LKP_NEW_BUR,
  {{ flag_evaluation('LKP_ROW_WID IS NULL', 'MD5(BUR) = MD5(LKP_NEW_BUR)') }} AS o_Flag,
  SYSDATE AS CDM_INSERT_DT,
  SYSDATE AS CDM_UPDATE_DT,
  'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM {{ ref('int_W_CLAIM_CD_BUR_SCD3') }}