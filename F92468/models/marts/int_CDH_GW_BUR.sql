-- Purpose: Extract data from CDH_GW_BUR with custom SQL query
WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME 
  FROM {{ source('W_CLAIM_CD_SCD3_IU', 'CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  BUR, 
  SOURCE_NAME 
FROM source_data