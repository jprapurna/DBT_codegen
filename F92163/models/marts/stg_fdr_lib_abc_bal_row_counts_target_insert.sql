{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'FDR_LIB_ABC_BAL_ROW_COUNTS_TARGET_INSERT') }}