{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    POLICY_STATE,
    BUR,
    SOURCE_NAME,
    -- Additional transformations for BUR logic
    TRIM(POLICY_STATE) AS trimmed_policy_state,
    TRIM(BUR) AS trimmed_bur
  FROM source_data
)

SELECT * FROM exp_bur