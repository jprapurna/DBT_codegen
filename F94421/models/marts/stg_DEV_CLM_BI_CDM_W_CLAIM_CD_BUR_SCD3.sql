{{ config(materialized='view') }}

WITH dev_clm_bi_cdm_w_claim_cd_bur_scd3 AS (
    SELECT
        "DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3" AS dev_clm_bi_cdm_w_claim_cd_bur_scd3 -- Syntax error in table name
    FROM {{ source('Snowflake_CDM', 'DEV_CLM_BI_CDM_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    dev_clm_bi_cdm_w_claim_cd_bur_scd3
FROM dev_clm_bi_cdm_w_claim_cd_bur_scd3