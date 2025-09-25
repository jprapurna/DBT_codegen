{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'STG_TFPLCY_TRAN_RESULT') }}