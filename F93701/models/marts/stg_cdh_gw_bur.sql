WITH source_data AS (
    SELECT 
        policy_state,
        bur,
        {{ var('source_name_gwcdm') }} AS source_name
    FROM {{ source('genai_power_bi', 'sq_cdh_gw_bur') }}
)
SELECT * FROM source_data