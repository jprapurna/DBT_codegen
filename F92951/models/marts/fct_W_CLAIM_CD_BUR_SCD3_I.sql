-- Purpose: Insert data into W_CLAIM_CD_BUR_SCD3_I
WITH insert_data AS (
  SELECT 
    exp_flag.o_Flag, 
    exp_flag.CDM_INSERT_DT, 
    exp_flag.CDM_UPDATE_DT, 
    exp_flag.TGT_TABLE_NAME, 
    row_wid.ROW_WID 
  FROM {{ ref('int_EXP_Flag') }} AS exp_flag
  JOIN {{ ref('int_mplt_CDM_ROW_WID') }} AS row_wid
  ON exp_flag.o_Flag = 'I'
)
SELECT 
  o_Flag, 
  CDM_INSERT_DT, 
  CDM_UPDATE_DT, 
  TGT_TABLE_NAME, 
  ROW_WID 
FROM insert_data