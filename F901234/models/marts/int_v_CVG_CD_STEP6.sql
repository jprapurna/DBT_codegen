-- Purpose: Local variable for coverage code step 6
WITH coverage_code_step6 AS (
  SELECT 
    IIF(ST_ABBR != 'WA', IIF(ACCTNG_LOB = '211CL' AND IN(CVG_TYP_CD, '20100', '20102', '20103'), '020', ...) AS v_CVG_CD_STEP6
)
SELECT 
  v_CVG_CD_STEP6 
FROM coverage_code_step6