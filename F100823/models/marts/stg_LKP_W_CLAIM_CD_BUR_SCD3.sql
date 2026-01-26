{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        "LKP_W_CLAIM_CD_BUR_SCD3" AS lkp_w_claim_cd_bur_scd3 -- Table identifier
    FROM {{ source('CDH_GWODS_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_w_claim_cd_bur_scd3
FROM lkp_w_claim_cd_bur_scd3