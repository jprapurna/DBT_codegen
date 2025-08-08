-- Purpose: Update strategy expression
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  'DD_UPDATE' AS Update_Strategy_Expression_78066
FROM 
  {{ ref('int_rtr_CLM_INSERT_UPD') }}
WHERE 
  o_Flag = 'U'