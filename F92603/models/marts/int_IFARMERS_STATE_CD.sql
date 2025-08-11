-- Purpose: Custom calculation for Farmers state code conversion.
WITH farmers_state_code_conversion AS (
  SELECT 
    TO_INTEGER(v_FARMERS_STATE_CD) AS farmers_state_cd_int
)
SELECT 
  farmers_state_cd_int
FROM farmers_state_code_conversion