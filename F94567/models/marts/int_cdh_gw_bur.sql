{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM source_data
),

final AS (
  SELECT *
  FROM exp_bur
)

SELECT * FROM final