{{ config(materialized='view') }}

WITH lookup_data AS (
    SELECT
        "lkp_ROW_WID" AS lkp_row_wid,             -- Lookup ROW_WID
        "lkp_INTEGRATION_ID" AS lkp_integration_id, -- Lookup Integration ID
        "lkp_NEW_BUR" AS lkp_new_bur             -- Lookup NEW BUR
    FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM lookup_data