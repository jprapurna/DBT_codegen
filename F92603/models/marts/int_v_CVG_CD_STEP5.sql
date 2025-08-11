-- Purpose: Local variable for coverage code step 5
SELECT 
  IIF(ACCTNG_LOB = '1923D' OR (ACCTNG_LOB = '192BI' AND IN(CVG_TYP_CD, '40011', '40012', '40013') AND (BI_LMT_1_Decimal = 0 OR BI_LMT_NO_OF_PARTS > 1 OR TO_CHAR(BI_LMT_1_Decimal) = ' ')), '001', ...) AS v_cvg_cd_step5
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}