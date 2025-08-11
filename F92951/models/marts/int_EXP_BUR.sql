-- Purpose: Rename POLICY_STATE to INTEGRATION_ID
WITH renamed_data AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID, 
    BUR, 
    SOURCE_NAME 
  FROM {{ ref('int_CDH_GW_BUR') }}
)
SELECT 
  INTEGRATION_ID, 
  BUR, 
  SOURCE_NAME 
FROM renamed_data