-- Purpose: XQuery expressions are employed for dynamic parameter assignments, enhancing workflow flexibility.
WITH exp_bur AS (
  SELECT 
    POLICY_STATE,
    -- Expression logic for POLICY_STATE to derive INTEGRATION_ID
    -- Assuming some logic here, replace with actual logic
    POLICY_STATE AS integration_id
  FROM {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE,
  integration_id
FROM exp_bur