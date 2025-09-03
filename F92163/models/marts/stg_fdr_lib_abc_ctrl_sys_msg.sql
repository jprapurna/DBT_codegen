{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'FDR_LIB_ABC_CTRL_SYS_MSG') }}