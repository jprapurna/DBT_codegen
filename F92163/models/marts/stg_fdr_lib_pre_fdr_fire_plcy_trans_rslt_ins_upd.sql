{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT_INS_UPD') }}