{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOURCE_NAME_GWCDM" AS source_name_gwcdm -- Source name for GWCDM
    FROM {{ source('genai_power_bi', 'source_name_gwcdm') }}
)
SELECT
    source_name_gwcdm
FROM source_data