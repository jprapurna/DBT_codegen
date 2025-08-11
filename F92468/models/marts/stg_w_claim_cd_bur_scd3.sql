{{ config(materialized='view') }}

SELECT
"row_wid" AS row_wid, -- Row identifier
"integration_id" AS integration_id, -- Integration identifier
"new_bur" AS new_bur -- New BUR data
FROM {{ source('genai_power_bi', 'w_claim_cd_bur_scd3') }}