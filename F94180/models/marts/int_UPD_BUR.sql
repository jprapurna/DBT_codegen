-- Purpose: Determines record operation using update strategy.
SELECT 
  INTEGRATION_ID AS in_INTEGRATION_ID,
  LKP_INTEGRATION_ID,
  o_Flag,
  BATCH_ID,
  'DD_UPDATE' AS Update_Strategy_Expression_78066
FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}