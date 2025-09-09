{{ config(materialized='view') }}

WITH dev_clm_bi_cdm_w_claim_cd_bur_scd3 AS (
    SELECT
        "DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3" AS dev_clm_bi_cdm_w_claim_cd_bur_scd3 -- Table identifier
    FROM {{ source('DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3', 'DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    dev_clm_bi_cdm_w_claim_cd_bur_scd3
FROM dev_clm_bi_cdm_w_claim_cd_bur_scd3