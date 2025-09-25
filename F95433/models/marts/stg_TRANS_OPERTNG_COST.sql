{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'TRANS_OPERTNG_COST') }}