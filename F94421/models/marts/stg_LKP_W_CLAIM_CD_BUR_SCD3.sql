{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        LKP_ROW_WID AS lkp_row_wid,                 -- Lookup row ID
        LKP_INTEGRATION_ID AS lkp_integration_id,   -- Lookup integration ID
        LKP_NEW_BUR AS lkp_new_bur                 -- Lookup new BUR value
    FROM {{ source('Snowflake_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM lkp_w_claim_cd_bur_scd3