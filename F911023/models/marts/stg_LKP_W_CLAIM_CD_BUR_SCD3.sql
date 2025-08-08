{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup row wide identifier
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration identifier
"LKP_NEW_BUR" AS lkp_new_bur -- New business unit reference
FROM {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}