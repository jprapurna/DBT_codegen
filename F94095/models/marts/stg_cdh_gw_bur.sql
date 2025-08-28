-- Purpose: Staging model for CDH_GW_BUR source table
WITH source_data AS (
    SELECT 
        POLICY_STATE,
        BUR,
        {{ ref('source_name_gwcdm') }} AS SOURCE_NAME
    FROM {{ source('genai_power_bi', 'sq_cdh_gw_bur') }}
)
SELECT * FROM source_data