{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('GENAI_POWER_BI_CDM', 'W_CLAIM_CD_BUR_SCD3') }}