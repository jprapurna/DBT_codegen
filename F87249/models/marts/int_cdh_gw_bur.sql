-- Purpose: Extract data from CDH_GW_BUR with custom SQL override
WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
)
SELECT * FROM source_data