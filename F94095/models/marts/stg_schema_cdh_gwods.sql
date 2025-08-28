{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SCHEMA_CDH_GWODS" AS schema_cdh_gwods -- Schema name for CDH_GWODS
    FROM {{ source('genai_power_bi', 'schema_cdh_gwods') }}
)
SELECT
    schema_cdh_gwods
FROM source_data