{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    '{{ var("source_name_gwcdm") }}' AS SOURCE_NAME
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
)
SELECT * FROM source_data