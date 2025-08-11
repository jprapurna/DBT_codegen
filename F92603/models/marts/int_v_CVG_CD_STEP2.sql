-- Purpose: Local variable for coverage code step 2
SELECT 
  IIF(ST_ABBR = 'MI', IIF(ACCTNG_LOB = '191PP', ...)) AS v_cvg_cd_step2
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}