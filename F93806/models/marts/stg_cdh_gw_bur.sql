WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    {{ var('SOURCE_NAME_GWCDM') }} AS SOURCE_NAME
  FROM {{ source('genai_power_bi', 'cdh_gw_bur') }}
)
SELECT * FROM source_data