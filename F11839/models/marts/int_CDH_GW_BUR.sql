-- Purpose: Extract data from CDH_GW_BUR source with custom SQL query
WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS source_name
  FROM 
    {{ source('W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  BUR, 
  source_name
FROM 
  source_data