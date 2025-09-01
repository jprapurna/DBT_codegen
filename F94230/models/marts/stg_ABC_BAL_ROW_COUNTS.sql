{{ config(materialized='view') }}

WITH abc_bal_row_counts AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'ABC_BAL_ROW_COUNTS') }}
)
SELECT
    *
FROM abc_bal_row_counts