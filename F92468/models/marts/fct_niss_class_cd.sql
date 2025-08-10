-- Purpose: Final model for reporting or analytics based on NISS_CLASS_CD

WITH final_niss_class_cd AS (
  SELECT 
    a.NISS_APRM_DETL_SK,
    a.NISS_CLASS_CD,
    b.v_CLASS_CD_Indemnity,
    b.v_CLASS_CD_Auto_1A,
    b.v_CLASS_CD_Auto_4,
    b.v_CLASS_CD_Auto_5,
    b.v_CLASS_CD_Auto_6
  FROM {{ ref('int_upd_niss_class_cd') }} a
  JOIN {{ ref('int_exp_to_drv_class_cd1') }} b
  ON a.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
)

SELECT 
  NISS_APRM_DETL_SK,
  NISS_CLASS_CD,
  v_CLASS_CD_Indemnity,
  v_CLASS_CD_Auto_1A,
  v_CLASS_CD_Auto_4,
  v_CLASS_CD_Auto_5,
  v_CLASS_CD_Auto_6
FROM final_niss_class_cd