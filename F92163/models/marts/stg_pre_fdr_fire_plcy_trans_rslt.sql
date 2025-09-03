{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}