-- Purpose: Extract data from CDH_GW_BUR table with custom SQL query and perform initial transformations.
WITH cdh_gw_bur AS (
  SELECT 
    POLICY_STATE,
    BUR,
    'GWCDH' AS source_name
  FROM {{ source('DBConnection_CDH_GWODS', 'CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE,
  BUR,
  source_name
FROM cdh_gw_bur