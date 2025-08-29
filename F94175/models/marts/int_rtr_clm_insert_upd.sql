SELECT 
  o_Flag,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  TGT_TABLE_NAME
FROM {{ ref('int_exp_flag') }}
WHERE o_Flag IN ('I', 'U')