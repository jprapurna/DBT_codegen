{{ config(materialized='view') }}

SELECT
    "s_W_CLAIM_CD_SCD3_IU" AS s_w_claim_cd_scd3_iu
FROM {{ source('genai_power_bi', 's_w_claim_cd_scd3_iu') }}