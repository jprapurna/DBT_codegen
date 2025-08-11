-- Purpose: Lookup transformation for Farmers state code.
WITH farmers_state_lookup AS (
  SELECT DISTINCT 
    FARMERS_STATE_CD, 
    STATE_CODE 
  FROM {{ source('FDR', 'REF_TFARMERS_STATE') }}
  WHERE END_EFF_DT = '2999-12-31'
)
SELECT 
  FARMERS_STATE_CD, 
  STATE_CODE 
FROM farmers_state_lookup