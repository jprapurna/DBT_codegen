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
    CASE 
      WHEN POLICY_STATE = 'NJ' THEN 'NJ_INTEGRATION_ID'
      ELSE POLICY_STATE
    END AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM source_data
)

SELECT *
FROM exp_bur