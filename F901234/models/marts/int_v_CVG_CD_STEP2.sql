-- Purpose: Local variable for coverage code step 2
WITH coverage_code_step2 AS (
  SELECT 
    IIF(ST_ABBR = 'MI', IIF(ACCTNG_LOB = '191PP', ...) AS v_CVG_CD_STEP2
)
SELECT 
  v_CVG_CD_STEP2 
FROM coverage_code_step2