-- Purpose: Custom calculation for Farmers state code.
WITH farmers_state_code AS (
  SELECT 
    IIF(ST_CD = '#','00',ST_CD) AS farmers_state_cd
)
SELECT 
  farmers_state_cd
FROM farmers_state_code