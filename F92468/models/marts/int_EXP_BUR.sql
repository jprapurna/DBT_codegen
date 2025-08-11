-- Purpose: Map POLICY_STATE to INTEGRATION_ID
SELECT 
    POLICY_STATE AS integration_id
FROM {{ ref('int_CDH_GW_BUR') }}