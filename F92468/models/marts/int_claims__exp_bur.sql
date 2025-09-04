{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM source_data
)

SELECT *
FROM exp_bur