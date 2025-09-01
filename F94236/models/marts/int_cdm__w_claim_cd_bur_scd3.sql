{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT
    LKP_ROW_WID,
    BUR,
    LKP_NEW_BUR,
    {{ macro_flag_logic('LKP_ROW_WID', 'BUR', 'LKP_NEW_BUR') }} AS flag
  FROM source_data
),

rtr_clm_insert_upd AS (
  SELECT
    *,
    CASE 
      WHEN flag = 'I' THEN 'INSERT'
      WHEN flag = 'U' THEN 'UPDATE'
      ELSE 'NO_CHANGE'
    END AS operation_type
  FROM exp_flag
)

SELECT * FROM rtr_clm_insert_upd