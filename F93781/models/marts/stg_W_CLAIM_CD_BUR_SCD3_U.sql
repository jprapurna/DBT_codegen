{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        ROW_WID AS row_wid,               -- Row identifier
        INTEGRATION_ID AS integration_id, -- Integration identifier
        NEW_BUR AS new_bur                -- New BUR value
    FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3_U') }}
)
SELECT
    row_wid,
    integration_id,
    new_bur
FROM source_data