{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__lkp_w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT
    *,
    CASE
      WHEN lkp_row_wid IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(lkp_new_bur) THEN 'NC'
      ELSE 'U'
    END AS o_flag
  FROM source_data
)

SELECT *
FROM exp_flag