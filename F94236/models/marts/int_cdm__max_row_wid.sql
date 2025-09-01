{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'custom_table') }}
)

SELECT * FROM source_data