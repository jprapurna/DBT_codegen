{{ config(materialized='view') }}

SELECT
    "lkp_ROW_WID" AS lkp_row_wid, -- Lookup ROW_WID
    "lkp_INTEGRATION_ID" AS lkp_integration_id, -- Lookup Integration ID
    "lkp_NEW_BUR" AS lkp_new_bur -- Lookup new BUR data
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'LKP_W_CLAIM_CD_BUR_SCD3') }}