{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'W_CLAIM_CD_BUR_SCD3') }}