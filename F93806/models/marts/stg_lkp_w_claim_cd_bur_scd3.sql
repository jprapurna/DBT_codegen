{{ config(materialized='view') }}

SELECT
    "LKP_W_CLAIM_CD_BUR_SCD3".*
FROM {{ source('genai_power_bi', 'lkp_w_claim_cd_bur_scd3') }}