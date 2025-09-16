{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

transformation_step AS (
  SELECT
    ROW_WID
  FROM source_data
)

SELECT *
FROM transformation_step