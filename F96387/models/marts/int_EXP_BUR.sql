-- Purpose: Map POLICY_STATE to INTEGRATION_ID
WITH expression_data AS (
    SELECT 
        POLICY_STATE AS integration_id
    FROM {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
    integration_id
FROM expression_data