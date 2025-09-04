{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('lkp_MAX_ROW_WID', 'lkp_MAX_ROW_WID') }}
)
SELECT
    * -- No columns specified in source.yml
FROM lkp_max_row_wid