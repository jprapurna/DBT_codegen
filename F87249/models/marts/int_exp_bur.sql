-- Purpose: Map POLICY_STATE to INTEGRATION_ID
WITH mapped_data AS (
  SELECT 
    POLICY_STATE,
    INTEGRATION_ID
  FROM {{ ref('policy_state_to_integration_id') }}
)
SELECT * FROM mapped_data