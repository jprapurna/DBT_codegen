{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        *
    FROM {{ source('CDH_GWODS', 'LKP_MAX_ROW_WID') }}
)
SELECT
    *
FROM lkp_max_row_wid