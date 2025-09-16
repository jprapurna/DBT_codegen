{{ config(materialized='view') }}

SELECT
    ROW_WID AS row_wid -- Row-wide identifier
FROM {{ source('Snowflake_CDM', 'ROW_WID') }}