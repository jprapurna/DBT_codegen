-- Purpose: Custom calculation for Farmers state code
WITH farmers_state_cd AS (
  SELECT 
    IIF(ST_CD = '#', '00', ST_CD) AS v_FARMERS_STATE_CD
)
SELECT 
  v_FARMERS_STATE_CD 
FROM farmers_state_cd