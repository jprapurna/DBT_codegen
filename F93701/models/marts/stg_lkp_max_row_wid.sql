{{ config(materialized='view') }}

SELECT
    "lkp_MAX_ROW_WID" AS lkp_max_row_wid
FROM {{ source('genai_power_bi', 'lkp_max_row_wid') }}