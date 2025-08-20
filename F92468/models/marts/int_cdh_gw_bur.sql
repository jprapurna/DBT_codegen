-- Purpose: Represents the source data from CDH_GW_BUR with custom SQL override

WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    'GWCDH' AS source_name
  FROM {{ source('GENAI_POWER_BI', 'SQ_CDH_GW_BUR') }}
)

SELECT 
  POLICY_STATE,
  BUR,
  source_name
FROM source_data