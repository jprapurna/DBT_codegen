{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('LKP_W_CLAIM_CD_BUR_SCD3', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    * -- No columns specified in source.yml
FROM lkp_w_claim_cd_bur_scd3