{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'TRANS_PRORT_FCTR') }}