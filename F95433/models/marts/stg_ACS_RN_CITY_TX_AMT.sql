{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'ACS_RN_CITY_TX_AMT') }}