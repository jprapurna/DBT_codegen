{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        -- No columns available for aliasing
    FROM {{ source('GENAI_POWER_BI', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    -- No columns available for selection
FROM lkp_w_claim_cd_bur_scd3