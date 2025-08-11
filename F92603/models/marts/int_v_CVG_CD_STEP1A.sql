-- Purpose: Local variable for coverage code step 1A
SELECT 
  IIF(ST_ABBR = 'FL', DECODE(1, ...)) AS v_cvg_cd_step1a
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}