{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        "ROW_WID" AS row_wid,              -- Row identifier
        "INTEGRATION_ID" AS integration_id, -- Integration identifier
        "NEW_BUR" AS new_bur               -- New burden data
    FROM {{ source('W_CLAIM_CD_BUR_SCD3', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    row_wid,
    integration_id,
    new_bur
FROM w_claim_cd_bur_scd3