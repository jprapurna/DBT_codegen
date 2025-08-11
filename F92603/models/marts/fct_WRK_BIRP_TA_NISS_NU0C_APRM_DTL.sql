-- Purpose: Final model for detailed reporting of written premium.
WITH final_detailed_reporting AS (
  SELECT 
    a.*, 
    b.grgng_zip_5, 
    c.farmers_state_cd_int, 
    d.cvg_cd_step1, 
    e.cvg_cd_step1a, 
    f.cvg_cd_step2, 
    g.cvg_cd_step3, 
    h.cvg_cd_step4, 
    i.cvg_cd_step5, 
    j.cvg_cd_step6, 
    k.cvg_cd_step7
  FROM {{ ref('int_SQL_Override') }} a
  JOIN {{ ref('int_GRGNG_ZIP_5') }} b ON a.GRNG_ZIP = b.GRNG_ZIP
  JOIN {{ ref('int_IFARMERS_STATE_CD') }} c ON a.ST_CD = c.ST_CD
  JOIN {{ ref('int_v_CVG_CD_STEP1') }} d ON a.CVG_TYP_CD = d.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP1A') }} e ON a.CVG_TYP_CD = e.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP2') }} f ON a.CVG_TYP_CD = f.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP3') }} g ON a.CVG_TYP_CD = g.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP4') }} h ON a.CVG_TYP_CD = h.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP5') }} i ON a.CVG_TYP_CD = i.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP6') }} j ON a.CVG_TYP_CD = j.CVG_TYP_CD
  JOIN {{ ref('int_v_CVG_CD_STEP7') }} k ON a.CVG_TYP_CD = k.CVG_TYP_CD
)
SELECT 
  *
FROM final_detailed_reporting