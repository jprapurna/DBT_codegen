{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'ACS_NB_CITY_TX_AMT') }}