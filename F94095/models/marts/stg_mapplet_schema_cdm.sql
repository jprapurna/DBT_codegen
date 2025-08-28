{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "Mapplet_SCHEMA_CDM" AS mapplet_schema_cdm -- Schema name for CDM mapplet
    FROM {{ source('genai_power_bi', 'mapplet_schema_cdm') }}
)
SELECT
    mapplet_schema_cdm
FROM source_data