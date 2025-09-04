{{ config(materialized='view') }}

WITH claim_cd_bur_scd3 AS (
    SELECT
        "LKP_ROW_WID" AS lkp_row_wid,             -- Lookup row identifier
        "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration ID
        "LKP_NEW_BUR" AS lkp_new_bur             -- New BUR lookup value
    FROM {{ source('DBA_COMMON_UTILS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM claim_cd_bur_scd3