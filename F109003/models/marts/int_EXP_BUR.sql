-- Purpose: Map POLICY_STATE to INTEGRATION_ID
WITH expression_data AS (
    SELECT 
        POLICY_STATE AS INTEGRATION_ID 
    FROM 
        {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
    INTEGRATION_ID 
FROM 
    expression_data