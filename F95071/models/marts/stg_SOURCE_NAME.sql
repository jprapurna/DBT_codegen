{{ config(materialized='view') }}

SELECT
    SOURCE_NAME AS source_name -- Source name details
FROM {{ source('Snowflake_CDM', 'SOURCE_NAME') }}