-- Purpose: Local variable for coverage code step 1A
WITH coverage_code_step1a AS (
  SELECT 
    IIF(ST_ABBR = 'FL', DECODE(1, ...) AS v_CVG_CD_STEP1A
)
SELECT 
  v_CVG_CD_STEP1A 
FROM coverage_code_step1a