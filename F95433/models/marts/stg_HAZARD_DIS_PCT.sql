{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'HAZARD_DIS_PCT') }}