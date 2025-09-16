{{ config(materialized='view') }}

SELECT
    SOURCE_NAME_GWCDM AS source_name_gwcdm -- Source name in GWCDM
FROM {{ source('Snowflake_CDM', 'SOURCE_NAME_GWCDM') }}