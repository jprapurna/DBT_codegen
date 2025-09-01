{{ config(materialized='view') }}

SELECT
    "W_CLAIM_CD_BUR_SCD3" AS w_claim_cd_bur_scd3 -- Table 'W_CLAIM_CD_BUR_SCD3' does not exist or not authorized
FROM {{ source('GENAI_POWER_BI_CDM', 'W_CLAIM_CD_BUR_SCD3') }}