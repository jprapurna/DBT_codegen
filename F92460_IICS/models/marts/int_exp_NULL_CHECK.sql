-- Purpose: Check for null values in BATCH_ID
SELECT 
  POLICY_STATE, 
  BUR, 
  INTEGRATION_ID, 
  IIF(ISNULL(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS BATCH_ID
FROM 
  {{ ref('int_mplt_CDM_BATCH_ID') }}