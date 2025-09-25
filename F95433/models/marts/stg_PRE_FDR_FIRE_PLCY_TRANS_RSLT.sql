{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('genai_power_bi', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}