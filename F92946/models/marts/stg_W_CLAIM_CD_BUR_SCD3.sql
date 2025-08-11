{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row identifier
"INTEGRATION_ID" AS integration_id, -- Integration identifier
"NEW_BUR" AS new_bur -- New BUR data
FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}