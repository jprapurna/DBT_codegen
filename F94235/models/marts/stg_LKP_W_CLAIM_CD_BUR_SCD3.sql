{{ config(materialized='view') }}

SELECT
    "LKP_ROW_WID" AS lkp_row_wid,           -- Row identifier
    "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Integration ID for lookup
    "LKP_NEW_BUR" AS lkp_new_bur            -- New BUR value for lookup
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}