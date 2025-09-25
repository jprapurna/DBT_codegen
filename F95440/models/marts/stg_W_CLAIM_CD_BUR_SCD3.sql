{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('GENAI_POWER_BI_CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM w_claim_cd_bur_scd3