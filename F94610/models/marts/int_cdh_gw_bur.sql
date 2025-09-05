{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),
exp_bur AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM source_data
)
SELECT *
FROM exp_bur