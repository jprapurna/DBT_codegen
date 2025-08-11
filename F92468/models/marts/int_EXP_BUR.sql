-- Purpose: Map POLICY_STATE to INTEGRATION_ID
WITH mapped_data AS (
  SELECT 
    POLICY_STATE, 
    -- Assuming a mapping logic exists here
    'INTEGRATION_ID' AS integration_id
  FROM {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  integration_id
FROM mapped_data