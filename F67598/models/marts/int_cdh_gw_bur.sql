-- Purpose: Extracts data from the table CDH_GW_BUR using a custom SQL query.
WITH source_data AS (
    SELECT 
        policy_state,
        bur,
        $$SOURCE_NAME_GWCDM AS source_name
    FROM {{ source('genai_power_bi', 'sq_cdh_gw_bur') }}
)
SELECT * FROM source_data