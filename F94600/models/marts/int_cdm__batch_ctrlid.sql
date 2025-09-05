{{ config(materialized='ephemeral') }}

WITH batch_ctrlid_data AS (
  SELECT 
    batch_ctrl_id
  FROM {{ source('cdm', 'batch_ctrlid') }}
)

SELECT * FROM batch_ctrlid_data