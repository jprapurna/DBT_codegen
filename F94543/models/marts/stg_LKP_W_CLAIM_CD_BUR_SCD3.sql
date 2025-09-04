{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        lkp_row_wid AS lkp_row_wid,               -- Row identifier for lookup
        lkp_integration_id AS lkp_integration_id, -- Integration ID for lookup
        lkp_new_bur AS lkp_new_bur                -- New business unit reference
    FROM {{ source('DBA_COMMON_UTILS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM lkp_w_claim_cd_bur_scd3