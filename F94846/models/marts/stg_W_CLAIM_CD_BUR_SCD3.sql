{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        "W_CLAIM_CD_BUR_SCD3" AS w_claim_cd_bur_scd3 -- Table identifier
    FROM {{ source('W_CLAIM_CD_BUR_SCD3', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    w_claim_cd_bur_scd3
FROM w_claim_cd_bur_scd3