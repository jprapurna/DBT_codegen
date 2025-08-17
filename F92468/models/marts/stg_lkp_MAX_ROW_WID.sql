{{ config(materialized='view') }}

SELECT
    "ROW_WID" AS row_wid, -- Maximum ROW_WID
    "TABLE_NAME" AS table_name -- Target table name
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'lkp_MAX_ROW_WID') }}