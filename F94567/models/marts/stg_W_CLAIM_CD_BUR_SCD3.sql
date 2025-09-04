{{ config(materialized='view') }}

WITH claim_cd_bur_scd3 AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('DBA_COMMON_UTILS', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM claim_cd_bur_scd3