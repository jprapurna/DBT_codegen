{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_upd_bur') }}
),

w_claim_cd_bur_scd3_u AS (
  SELECT 
    ROW_WID
  FROM source_data
),

final AS (
  SELECT *
  FROM w_claim_cd_bur_scd3_u
)

SELECT * FROM final