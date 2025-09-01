{{ config(materialized='view') }}

SELECT
    LKP_ROW_WID AS lkp_row_wid,                 -- Lookup row WID column
    LKP_INTEGRATION_ID AS lkp_integration_id,   -- Lookup integration ID column
    LKP_NEW_BUR AS lkp_new_bur                  -- Lookup new BUR column
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}