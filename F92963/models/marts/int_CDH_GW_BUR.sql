-- Purpose: Extract data from CDH_GW_BUR table with custom SQL query
WITH source_data AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        'GWCDH' AS source_name
    FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
)
SELECT 
    POLICY_STATE, 
    BUR, 
    source_name
FROM source_data