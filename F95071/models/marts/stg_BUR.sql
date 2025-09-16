{{ config(materialized='view') }}

SELECT
    BUR AS bur -- Burden information
FROM {{ source('Snowflake_CDM', 'BUR') }}