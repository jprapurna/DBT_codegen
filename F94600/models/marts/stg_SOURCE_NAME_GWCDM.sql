{{ config(materialized='view') }}

WITH source_name_gwcdm_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'SOURCE_NAME_GWCDM') }}
)
SELECT
    *
FROM source_name_gwcdm_data