-- Purpose: Expression transformation mapping POLICY_STATE to INTEGRATION_ID
WITH expression_data AS (
  SELECT 
    POLICY_STATE, 
    POLICY_STATE AS integration_id
  FROM 
    {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  integration_id
FROM 
  expression_data