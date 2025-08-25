-- Purpose: Extract data from CDH_GW_BUR source table
WITH source_data AS (
  SELECT
    POLICY_STATE,
    BUR,
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('cdh_gw_bur', 'sq_cdh_gw_bur') }}
)
SELECT *
FROM source_data