{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'TRN_POLICY_FEE_AMT') }}