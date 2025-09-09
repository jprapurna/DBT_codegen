{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        * -- No columns provided in source.yml
    FROM {{ source('W_CLAIM_CD_BUR_SCD3', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    * -- No columns provided in source.yml
FROM w_claim_cd_bur_scd3