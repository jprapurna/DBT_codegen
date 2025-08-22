-- Purpose: Applies field-level transformations, mapping POLICY_STATE to INTEGRATION_ID.
SELECT 
  POLICY_STATE, 
  BUR, 
  SOURCE_NAME, 
  POLICY_STATE AS INTEGRATION_ID
FROM {{ ref('int_CDH_GW_BUR') }}