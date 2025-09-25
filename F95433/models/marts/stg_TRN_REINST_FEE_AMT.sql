{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'TRN_REINST_FEE_AMT') }}