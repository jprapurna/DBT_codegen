{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'DEV_CLM_BI') }}