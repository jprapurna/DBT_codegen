{{ config(materialized='ephemeral') }}

WITH batch_ctrlid AS (
  SELECT 
    ROW_WID,
    TABLE_NAME
  FROM {{ source('cdm', 'custom_table') }}
)

SELECT * FROM batch_ctrlid