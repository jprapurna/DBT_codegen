-- Purpose: Extract data from CDH_GW_BUR source with custom SQL query
WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME 
  FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}
)
SELECT 
  POLICY_STATE, 
  BUR, 
  SOURCE_NAME 
FROM source_data