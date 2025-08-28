{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "lkp_ROW_WID" AS lkp_row_wid,           -- Lookup row ID
        "lkp_INTEGRATION_ID" AS lkp_integration_id, -- Integration ID for lookup
        "lkp_NEW_BUR" AS lkp_new_bur           -- New business unit region
    FROM {{ source('genai_power_bi', 'lkp_w_claim_cd_bur_scd3') }}
)
SELECT
    lkp_row_wid,
    lkp_integration_id,
    lkp_new_bur
FROM source_data