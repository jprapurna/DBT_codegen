-- Purpose: Local variable for coverage code step 5.
WITH coverage_code_step5 AS (
  SELECT 
    IIF(ACCTNG_LOB = '1923D' OR (ACCTNG_LOB = '192BI' AND IN(CVG_TYP_CD,'40011','40012','40013') AND (BI_LMT_1_Decimal = 0 OR BI_LMT_NO_OF_PARTS > 1 OR TO_CHAR(BI_LMT_1_Decimal) =' ' )),'001',...) AS cvg_cd_step5
)
SELECT 
  cvg_cd_step5
FROM coverage_code_step5