-- Purpose: Local variable for coverage code step 4
WITH coverage_code_step4 AS (
  SELECT 
    IIF(IN(ST_ABBR, 'AL', 'CO', 'MI', 'NV', 'OK', 'VA', 'OR', 'WA', 'KS') AND ACCTNG_LOB = '192UM' AND IN(CVG_TYP_CD, '13100', '11100', ...), ...) AS v_CVG_CD_STEP4
)
SELECT 
  v_CVG_CD_STEP4 
FROM coverage_code_step4