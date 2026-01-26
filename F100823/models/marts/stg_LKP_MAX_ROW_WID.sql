{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        "lkp_MAX_ROW_WID" AS lkp_max_row_wid -- Table identifier
    FROM {{ source('CDH_GWODS_CDM', 'lkp_MAX_ROW_WID') }}
)
SELECT
    lkp_max_row_wid
FROM lkp_max_row_wid