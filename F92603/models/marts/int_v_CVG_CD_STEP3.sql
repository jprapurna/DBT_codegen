-- Purpose: Local variable for coverage code step 3
SELECT 
  IIF(NOT IN(ST_ABBR, 'VA', 'MT') AND ACCTNG_LOB = '192MD', '003', ...) AS v_cvg_cd_step3
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}