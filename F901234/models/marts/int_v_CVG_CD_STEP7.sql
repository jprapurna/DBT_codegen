-- Purpose: Local variable for coverage code step 7
WITH coverage_code_step7 AS (
  SELECT 
    IIF(IN(ST_ABBR, 'MN', 'SD', 'NE') AND ACCTNG_LOB = '192UM' AND RATNG_CMPY_CD = 'N', IIF(IN(CVG_TYP_CD, '11100', ...), ...) AS v_CVG_CD_STEP7
)
SELECT 
  v_CVG_CD_STEP7 
FROM coverage_code_step7