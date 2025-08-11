-- Purpose: Local variable for coverage code step 4.
WITH coverage_code_step4 AS (
  SELECT 
    IIF(IN(ST_ABBR,'AL','CO','MI','NV','OK','VA','OR','WA','KS') AND ACCTNG_LOB = '192UM' AND IN(CVG_TYP_CD,'13100','11100',...) AS cvg_cd_step4
)
SELECT 
  cvg_cd_step4
FROM coverage_code_step4