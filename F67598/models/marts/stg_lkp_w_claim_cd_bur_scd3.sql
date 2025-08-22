{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        "LKP_ROW_WID" AS lkp_row_wid,             -- Row identifier for lookup
        "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Integration ID for lookup
        "LKP_NEW_BUR" AS lkp_new_bur             -- New BUR value for lookup
    FROM {{ source('genai_power_bi', 'lkp_w_claim_cd_bur_scd3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM lkp_w_claim_cd_bur_scd3