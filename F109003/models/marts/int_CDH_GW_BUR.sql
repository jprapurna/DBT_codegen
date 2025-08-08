-- Purpose: Extract data from CDH_GW_BUR with custom SQL query
WITH source_data AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        'GWCDH' AS SOURCE_NAME 
    FROM 
        {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
)
SELECT 
    POLICY_STATE, 
    BUR, 
    SOURCE_NAME 
FROM 
    source_data