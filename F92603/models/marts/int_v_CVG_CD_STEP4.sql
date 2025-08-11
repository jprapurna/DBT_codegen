-- Purpose: Local variable for coverage code step 4
SELECT 
  IIF(IN(ST_ABBR, 'AL', 'CO', 'MI', 'NV', 'OK', 'VA', 'OR', 'WA', 'KS') AND ACCTNG_LOB = '192UM' AND IN(CVG_TYP_CD, '13100', '11100', ...)) AS v_cvg_cd_step4
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}