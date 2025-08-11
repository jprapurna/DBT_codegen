-- Purpose: Set flags and timestamps based on input conditions
WITH flag_data AS (
  SELECT 
    BUR, 
    LKP_ROW_WID, 
    LKP_NEW_BUR, 
    CASE 
      WHEN LKP_ROW_WID IS NULL THEN 'I' 
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC' 
      ELSE 'U' 
    END AS o_Flag, 
    CURRENT_TIMESTAMP() AS CDM_INSERT_DT, 
    CURRENT_TIMESTAMP() AS CDM_UPDATE_DT, 
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME 
  FROM {{ ref('int_EXP_BUR') }} AS exp_bur
  LEFT JOIN {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }} AS lkp_bur
  ON exp_bur.INTEGRATION_ID = lkp_bur.lkp_INTEGRATION_ID
)
SELECT 
  o_Flag, 
  CDM_INSERT_DT, 
  CDM_UPDATE_DT, 
  TGT_TABLE_NAME 
FROM flag_data