{{ config(materialized='view') }}

WITH claim_cd_bur_scd3 AS (
    SELECT
        "LKP_ROW_WID" AS lkp_row_wid,             -- Row identifier for the lookup table
        "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Integration ID for the lookup table
        "LKP_NEW_BUR" AS lkp_new_bur              -- New BUR value in the lookup table
    FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM claim_cd_bur_scd3