{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'FDR_LIB_STG_TFPLCY_TRAN_RESULT') }}