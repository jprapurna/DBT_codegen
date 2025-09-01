{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        -- No columns available for this table
    FROM {{ source('GENAI_POWER_BI_CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    -- No columns available for this table
FROM w_claim_cd_bur_scd3