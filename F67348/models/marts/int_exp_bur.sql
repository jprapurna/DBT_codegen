-- Purpose: Expression transformation mapping POLICY_STATE to INTEGRATION_ID.
SELECT 
    POLICY_STATE,
    POLICY_STATE AS INTEGRATION_ID
FROM {{ ref('int_cdh_gw_bur') }}