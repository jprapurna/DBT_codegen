-- Purpose: Local variable for coverage code step 1
WITH coverage_code_step1 AS (
  SELECT 
    IIF(ST_ABBR = 'AR' AND ACCTNG_LOB = '191', '001', ...) AS v_CVG_CD_STEP1
)
SELECT 
  v_CVG_CD_STEP1 
FROM coverage_code_step1