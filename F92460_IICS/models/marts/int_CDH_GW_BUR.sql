-- Purpose: Extract data from CDH_GW_BUR source with custom SQL query
SELECT 
  POLICY_STATE, 
  BUR, 
  'GWCDH' AS SOURCE_NAME 
FROM 
  {{ source('CDH_GWODS', 'CDH_GW_BUR') }}