{{ config(materialized='view') }}

SELECT
"LKP_ROW_WID" AS lkp_row_wid, -- Lookup row WID
"LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration ID
"LKP_NEW_BUR" AS lkp_new_bur -- Lookup new BUR
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'LKP_W_CLAIM_CD_BUR_SCD3') }}