{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'CDM_ROW_WID') }}