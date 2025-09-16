{{ config(materialized='view') }}

SELECT
    PMError AS pmerror -- PM error information
FROM {{ source('Snowflake_CDM', 'PMError') }}