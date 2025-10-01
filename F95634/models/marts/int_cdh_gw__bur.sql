{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    *,
    CASE 
      WHEN POLICY_STATE = 'NJ' THEN 'New Jersey'
      ELSE POLICY_STATE
    END AS normalized_policy_state
  FROM source_data
)

SELECT * FROM exp_bur