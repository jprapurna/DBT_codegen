-- Purpose: Detailed final model for reporting and analytics on policy and coverage details
WITH detailed_policy_coverage AS (
  SELECT 
    a.*, 
    b.GRGNG_ZIP_5, 
    c.IFARMERS_STATE_CD, 
    d.v_CVG_CD_STEP1, 
    e.v_CVG_CD_STEP1A, 
    f.v_CVG_CD_STEP2, 
    g.v_CVG_CD_STEP3, 
    h.v_CVG_CD_STEP4, 
    i.v_CVG_CD_STEP5, 
    j.v_CVG_CD_STEP6, 
    k.v_CVG_CD_STEP7 
  FROM {{ ref('int_SQL_Override') }} a
  JOIN {{ ref('int_GRGNG_ZIP_5') }} b ON a.GRGNG_ZIP_5 = b.GRGNG_ZIP_5
  JOIN {{ ref('int_IFARMERS_STATE_CD') }} c ON a.ST_CD = c.IFARMERS_STATE_CD
  JOIN {{ ref('int_v_CVG_CD_STEP1') }} d ON a.CVG_TYP_CD = d.v_CVG_CD_STEP1
  JOIN {{ ref('int_v_CVG_CD_STEP1A') }} e ON a.CVG_TYP_CD = e.v_CVG_CD_STEP1A
  JOIN {{ ref('int_v_CVG_CD_STEP2') }} f ON a.CVG_TYP_CD = f.v_CVG_CD_STEP2
  JOIN {{ ref('int_v_CVG_CD_STEP3') }} g ON a.CVG_TYP_CD = g.v_CVG_CD_STEP3
  JOIN {{ ref('int_v_CVG_CD_STEP4') }} h ON a.CVG_TYP_CD = h.v_CVG_CD_STEP4
  JOIN {{ ref('int_v_CVG_CD_STEP5') }} i ON a.CVG_TYP_CD = i.v_CVG_CD_STEP5
  JOIN {{ ref('int_v_CVG_CD_STEP6') }} j ON a.CVG_TYP_CD = j.v_CVG_CD_STEP6
  JOIN {{ ref('int_v_CVG_CD_STEP7') }} k ON a.CVG_TYP_CD = k.v_CVG_CD_STEP7
)
SELECT 
  * 
FROM detailed_policy_coverage