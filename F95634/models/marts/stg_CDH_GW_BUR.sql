{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('GENAI_POWER_BI_CDM', 'CDH_GW_BUR') }}