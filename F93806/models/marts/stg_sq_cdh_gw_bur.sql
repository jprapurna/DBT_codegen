{{ config(materialized='view') }}

SELECT
    "SQ_CDH_GW_BUR".*
FROM {{ source('genai_power_bi', 'sq_cdh_gw_bur') }}