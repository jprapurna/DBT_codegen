{{ config(materialized='table') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_claim__row_wid') }}
)

SELECT *
FROM source_data