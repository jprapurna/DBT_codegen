{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'ABC_BAL_ROW_COUNTS') }}