-- Purpose: Local variable for coverage code step 6
SELECT 
  IIF(ST_ABBR != 'WA', IIF(ACCTNG_LOB = '211CL' AND IN(CVG_TYP_CD, '20100', '20102', '20103'), '020', ...)) AS v_cvg_cd_step6
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}