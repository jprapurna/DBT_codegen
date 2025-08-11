-- Purpose: Local variable for coverage code step 3.
WITH coverage_code_step3 AS (
  SELECT 
    IIF(NOT IN(ST_ABBR,'VA','MT') AND ACCTNG_LOB = '192MD','003',...) AS cvg_cd_step3
)
SELECT 
  cvg_cd_step3
FROM coverage_code_step3