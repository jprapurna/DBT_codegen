-- Purpose: Update operation on W_CLAIM_CD_BUR_SCD3_U
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  Update_Strategy_Expression_78066
FROM 
  {{ ref('int_UPD_BUR') }}