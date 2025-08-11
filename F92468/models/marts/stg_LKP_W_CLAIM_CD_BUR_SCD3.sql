{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup Row Wide Identifier
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup Integration Identifier
"LKP_NEW_BUR" AS lkp_new_bur -- Lookup New Business Unit Reference
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'LKP_W_CLAIM_CD_BUR_SCD3') }}