-- Purpose: Extract data from CDH_GW_BUR with SQL override using variables
WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME 
  FROM {{ source('IICS', 'SQ_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  BUR, 
  SOURCE_NAME 
FROM source_data