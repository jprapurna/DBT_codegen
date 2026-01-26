{{
  config(materialized='ephemeral')
}}

WITH exp_bur AS (
  SELECT 
    POLICY_STATE AS integration_id,
    BUR AS bur,
    SOURCE_NAME AS source_name
  FROM {{ source('cdh_gwods_cdm', 'sq_cdh_gw_bur') }}
)

SELECT *
FROM exp_bur