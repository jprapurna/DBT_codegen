-- Purpose: Local variable for coverage code step 3
WITH coverage_code_step3 AS (
  SELECT 
    IIF(NOT IN(ST_ABBR, 'VA', 'MT') AND ACCTNG_LOB = '192MD', '003', ...) AS v_CVG_CD_STEP3
)
SELECT 
  v_CVG_CD_STEP3 
FROM coverage_code_step3