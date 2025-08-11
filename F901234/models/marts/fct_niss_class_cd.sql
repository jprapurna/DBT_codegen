-- Purpose: Role in reporting or analytics

WITH updated_data AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    rec_excp_ind,
    rec_excp_desc
  FROM {{ ref('int_upd_niss_class_cd') }}
),
expression_data AS (
  SELECT
    NISS_APRM_DETL_SK,
    v_class_cd_indemnity,
    v_class_cd_auto_1,
    v_class_cd_auto_1a,
    v_class_cd_auto_2,
    v_class_cd_auto_3,
    v_class_cd_auto_4,
    v_class_cd_auto_5,
    v_class_cd_auto_6
  FROM {{ ref('int_exp_to_drv_class_cd1') }}
)

SELECT
  u.NISS_APRM_DETL_SK,
  u.NISS_CLASS_CD,
  u.rec_excp_ind,
  u.rec_excp_desc,
  e.v_class_cd_indemnity,
  e.v_class_cd_auto_1,
  e.v_class_cd_auto_1a,
  e.v_class_cd_auto_2,
  e.v_class_cd_auto_3,
  e.v_class_cd_auto_4,
  e.v_class_cd_auto_5,
  e.v_class_cd_auto_6
FROM updated_data u
JOIN expression_data e ON u.NISS_APRM_DETL_SK = e.NISS_APRM_DETL_SK