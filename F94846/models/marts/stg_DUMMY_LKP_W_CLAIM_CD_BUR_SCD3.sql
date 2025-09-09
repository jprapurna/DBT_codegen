{{ config(materialized='view') }}

WITH dummy_lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        "DUMMY_LKP_W_CLAIM_CD_BUR_SCD3" AS dummy_lkp_w_claim_cd_bur_scd3 -- Table identifier
    FROM {{ source('DUMMY_LKP_W_CLAIM_CD_BUR_SCD3', 'DUMMY_LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    dummy_lkp_w_claim_cd_bur_scd3
FROM dummy_lkp_w_claim_cd_bur_scd3