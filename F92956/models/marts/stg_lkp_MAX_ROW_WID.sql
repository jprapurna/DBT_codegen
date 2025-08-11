{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row width
"TABLE_NAME" AS table_name -- Table name
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'lkp_MAX_ROW_WID') }}