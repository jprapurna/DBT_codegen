{{ config(materialized='view') }}

SELECT
    "W_CLAIM_CD_BUR_SCD3_I".*
FROM {{ source('genai_power_bi', 'w_claim_cd_bur_scd3_i') }}