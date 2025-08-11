{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup row ID
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration ID
"LKP_NEW_BUR" AS lkp_new_bur -- Lookup new business unit reference
FROM {{ source('CLAIM_DATA', 'LKP_W_CLAIM_CD_BUR_SCD3') }}