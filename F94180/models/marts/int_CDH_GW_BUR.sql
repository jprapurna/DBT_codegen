-- Purpose: Extracts data from the source table CDH_GW_BUR with schema and source name substitution.
SELECT 
  POLICY_STATE,
  BUR,
  'GWCDH' AS SOURCE_NAME
FROM {{ source('CDH_GWODS', 'DUMMY_SQ_CDH_GW_BUR') }}