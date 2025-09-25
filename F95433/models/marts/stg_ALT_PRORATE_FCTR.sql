{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'ALT_PRORATE_FCTR') }}