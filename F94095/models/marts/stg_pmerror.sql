{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ERROR_LOG" AS error_log -- Error log file
    FROM {{ source('genai_power_bi', 'pmerror') }}
)
SELECT
    error_log
FROM source_data