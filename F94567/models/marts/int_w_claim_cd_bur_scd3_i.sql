{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_rtr_clm_insert_upd') }}
),

w_claim_cd_bur_scd3_i AS (
  SELECT 
    NEW_BUR
  FROM source_data
  WHERE o_Flag = 'I'
),

final AS (
  SELECT *
  FROM w_claim_cd_bur_scd3_i
)

SELECT * FROM final