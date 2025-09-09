{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    $$TGT_TABLE_NAME AS TABLE_NAME
  FROM {{ source('cdm', 'custom_table') }}
)
SELECT *
FROM source_data