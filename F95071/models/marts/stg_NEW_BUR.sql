{{ config(materialized='view') }}

SELECT
    NEW_BUR AS new_bur -- New burden information
FROM {{ source('Snowflake_CDM', 'NEW_BUR') }}