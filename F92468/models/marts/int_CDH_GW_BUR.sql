-- Purpose: Extract data from CDH_GW_BUR with custom SQL query
WITH source_data AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        'GWCDH' AS SOURCE_NAME 
    FROM {{ source('genai_power_bi', 'cdh_gw_bur') }}
)
SELECT 
    POLICY_STATE, 
    BUR, 
    SOURCE_NAME 
FROM source_data