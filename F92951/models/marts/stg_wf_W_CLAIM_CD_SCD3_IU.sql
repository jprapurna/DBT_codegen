{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid -- Row WID for update
FROM {{ source('IICS', 'wf_W_CLAIM_CD_SCD3_IU') }}