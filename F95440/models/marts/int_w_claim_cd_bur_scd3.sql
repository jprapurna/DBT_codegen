{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_claim_cd_bur AS (
  SELECT
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR,
    {{ macro_isnull('LKP_NEW_BUR') }} AS NEW_BUR_CLEANED
  FROM source_data
)

SELECT * FROM exp_claim_cd_bur;