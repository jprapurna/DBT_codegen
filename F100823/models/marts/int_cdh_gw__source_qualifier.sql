{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdh_gwods_cdm', 'sq_cdh_gw_bur') }}
)

SELECT *
FROM source_data