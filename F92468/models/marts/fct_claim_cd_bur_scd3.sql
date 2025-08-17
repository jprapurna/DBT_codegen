SELECT 
  ROW_WID,
  BUR,
  NEW_BUR,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  o_Flag
FROM {{ ref('int_claim_cd_bur_scd3') }}
WHERE o_Flag IN ('I', 'U');