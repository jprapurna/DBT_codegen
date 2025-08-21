{{ config(materialized='view') }}

WITH lookup_data AS (
    SELECT
        "LKP_ROW_WID" AS lkp_row_wid,               -- Lookup row identifier
        "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Integration ID for lookup
        "LKP_NEW_BUR" AS lkp_new_bur               -- New BUR value from lookup
    FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM lookup_data