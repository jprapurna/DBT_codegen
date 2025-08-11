-- Purpose: Local variable for coverage code step 1
SELECT 
  IIF(ST_ABBR = 'AR' AND ACCTNG_LOB = '191', '001', ...) AS v_cvg_cd_step1
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}