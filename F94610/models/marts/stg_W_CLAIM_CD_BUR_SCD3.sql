{{ config(materialized='view') }}

WITH claim_cd_bur_scd3 AS (
    SELECT
        "ROW_WID" AS row_wid,               -- Unique row identifier
        "INTEGRATION_ID" AS integration_id, -- Integration identifier for claims
        "NEW_BUR" AS new_bur                -- New burden data
    FROM {{ source('CDH_GW_BUR', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    row_wid,
    integration_id,
    new_bur
FROM claim_cd_bur_scd3