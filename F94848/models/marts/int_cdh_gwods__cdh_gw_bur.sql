{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    $$SOURCE_NAME_GWCDM AS SOURCE_NAME
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),
exp_bur AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    SOURCE_NAME,
    MD5(POLICY_STATE || BUR || SOURCE_NAME) AS INTEGRATION_ID
  FROM source_data
)
SELECT *
FROM exp_bur