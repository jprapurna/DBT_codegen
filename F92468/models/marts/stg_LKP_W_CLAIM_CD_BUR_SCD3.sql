{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup row identifier
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Integration identifier for lookup
"LKP_NEW_BUR" AS lkp_new_bur -- New business unit reference in lookup
FROM {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}