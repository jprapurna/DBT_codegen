{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row WID information
"TABLE_NAME" AS table_name -- Table name information
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'lkp_MAX_ROW_WID') }}