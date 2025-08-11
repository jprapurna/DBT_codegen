-- Purpose: Renames POLICY_STATE to INTEGRATION_ID.
WITH exp_bur AS (
    SELECT 
        POLICY_STATE AS integration_id
    FROM 
        {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
    integration_id
FROM 
    exp_bur