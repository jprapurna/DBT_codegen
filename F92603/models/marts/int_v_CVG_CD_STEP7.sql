-- Purpose: Local variable for coverage code step 7
SELECT 
  IIF(IN(ST_ABBR, 'MN', 'SD', 'NE') AND ACCTNG_LOB = '192UM' AND RATNG_CMPY_CD = 'N', IIF(IN(CVG_TYP_CD, '11100', ...)) AS v_cvg_cd_step7
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}