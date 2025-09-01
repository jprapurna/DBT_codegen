{{ config(materialized='view') }}

SELECT
    "CDH_GW_BUR" AS cdh_gw_bur -- Table 'CDH_GW_BUR' does not exist or not authorized
FROM {{ source('GENAI_POWER_BI_CDM', 'CDH_GW_BUR') }}