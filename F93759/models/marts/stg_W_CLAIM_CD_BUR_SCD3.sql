{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "BUR" AS bur,                        -- BUR identifier
        "LKP_NEW_BUR" AS lkp_new_bur,        -- Lookup new BUR
        "O_FLAG" AS o_flag,                  -- Operational flag
        "IN_INTEGRATION_ID" AS in_integration_id, -- Integration ID
        "LKP_INTEGRATION_ID" AS lkp_integration_id, -- Lookup integration ID
        "LKP_ROW_WID" AS lkp_row_wid,        -- Lookup row ID
        "BATCH_ID" AS batch_id,              -- Batch ID
        "NEW_BUR" AS new_bur,                -- New BUR identifier
        "OLD_BUR" AS old_bur,                -- Old BUR identifier
        "ROW_WID" AS row_wid                 -- Row ID
    FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    bur,
    lkp_new_bur,
    o_flag,
    in_integration_id,
    lkp_integration_id,
    lkp_row_wid,
    batch_id,
    new_bur,
    old_bur,
    row_wid
FROM source_data