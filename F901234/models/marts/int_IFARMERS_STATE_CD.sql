-- Purpose: Custom calculation for Farmers state code conversion
WITH farmers_state_conversion AS (
  SELECT 
    TO_INTEGER(v_FARMERS_STATE_CD) AS IFARMERS_STATE_CD
)
SELECT 
  IFARMERS_STATE_CD 
FROM farmers_state_conversion