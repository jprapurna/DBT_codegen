{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup row identifier
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration identifier
"LKP_NEW_BUR" AS lkp_new_bur -- Lookup new BUR value
FROM {{ source('IICS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}