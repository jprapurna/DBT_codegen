-- Purpose: Rename POLICY_STATE to INTEGRATION_ID
WITH renamed_data AS (
    SELECT 
        POLICY_STATE AS integration_id
    FROM {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
    integration_id
FROM renamed_data