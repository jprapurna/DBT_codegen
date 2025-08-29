-- Purpose: Processes input fields and maps POLICY_STATE to INTEGRATION_ID.
SELECT 
  POLICY_STATE,
  BUR,
  SOURCE_NAME,
  {{ ref('state_policy_mapping') }}.INTEGRATION_ID
FROM {{ ref('int_CDH_GW_BUR') }}
LEFT JOIN {{ ref('state_policy_mapping') }} ON POLICY_STATE = {{ ref('state_policy_mapping') }}.POLICY_STATE