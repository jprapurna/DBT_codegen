{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        -- No columns available for aliasing
    FROM {{ source('GENAI_POWER_BI', 'LKP_MAX_ROW_WID') }}
)
SELECT
    -- No columns available for selection
FROM lkp_max_row_wid