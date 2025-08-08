-- Purpose: Insert operation on W_CLAIM_CD_BUR_SCD3_I
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  ROW_WID
FROM 
  {{ ref('int_mplt_CDM_ROW_WID') }}