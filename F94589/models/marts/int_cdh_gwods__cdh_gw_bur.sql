{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),
EXP_BUR AS (
  SELECT
    *,
    CASE 
      WHEN business_unit IS NULL THEN 'UNKNOWN'
      ELSE business_unit
    END AS business_unit_checked
  FROM source_data
)
SELECT * FROM EXP_BUR