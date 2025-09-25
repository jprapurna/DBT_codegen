{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'TRN_BILLED_TAX_AMT') }}