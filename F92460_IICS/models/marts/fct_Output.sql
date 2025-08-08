-- Purpose: Write data to target table
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  ROW_WID
FROM 
  {{ ref('int_exp_ROW_WID') }}