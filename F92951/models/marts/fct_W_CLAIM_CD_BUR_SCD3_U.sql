-- Purpose: Update data in W_CLAIM_CD_BUR_SCD3_U based on Update Strategy Expression
WITH update_data AS (
  SELECT 
    exp_flag.o_Flag, 
    exp_flag.CDM_INSERT_DT, 
    exp_flag.CDM_UPDATE_DT, 
    exp_flag.TGT_TABLE_NAME, 
    upd_bur.Update_Strategy_Expression_78066 
  FROM {{ ref('int_EXP_Flag') }} AS exp_flag
  JOIN {{ ref('int_UPD_BUR') }} AS upd_bur
  ON exp_flag.o_Flag = 'U'
)
SELECT 
  o_Flag, 
  CDM_INSERT_DT, 
  CDM_UPDATE_DT, 
  TGT_TABLE_NAME, 
  Update_Strategy_Expression_78066 
FROM update_data