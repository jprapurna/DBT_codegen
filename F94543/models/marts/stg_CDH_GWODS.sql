{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('DBA_COMMON_UTILS', 'CDH_GWODS') }}