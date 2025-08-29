{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        ROW_WID AS row_wid,         -- Maximum row ID
        TABLE_NAME AS table_name    -- Target table name
    FROM {{ source('CDM', 'DUMMY_mplt_CDM_ROW_WID_lkp_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM source_data