-- Purpose: Final model for reporting or analytics based on the update and expression transformations.

WITH updated_class_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC
  FROM {{ ref('int_upd_niss_class_cd') }}
),

derived_class_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ST_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    RT_CLS,
    AGE,
    GENDR,
    MRTL_STAT,
    auto_use_cd,
    iage,
    imiles_to_wrk,
    GOOD_STDNT_IND,
    DRVR_TRNG_IND,
    SOI_TYP,
    ACCTNG_LOB,
    CVG_TYP_CD,
    NISS_CLASS_CD_FL,
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
  u.REC_EXCPN_IND,
  u.REC_EXCPN_RSN_DESC,
  d.ST_ABBR,
  d.ST_CD,
  d.RATNG_CMPY_CD,
  d.MLT_CAR_IND,
  d.RT_CLS,
  d.AGE,
  d.GENDR,
  d.MRTL_STAT,
  d.auto_use_cd,
  d.iage,
  d.imiles_to_wrk,
  d.GOOD_STDNT_IND,
  d.DRVR_TRNG_IND,
  d.SOI_TYP,
  d.ACCTNG_LOB,
  d.CVG_TYP_CD,
  d.NISS_CLASS_CD_FL,
  d.v_class_cd_indemnity,
  d.v_class_cd_auto_1,
  d.v_class_cd_auto_1a,
  d.v_class_cd_auto_2,
  d.v_class_cd_auto_3,
  d.v_class_cd_auto_4,
  d.v_class_cd_auto_5,
  d.v_class_cd_auto_6
FROM updated_class_cd u
JOIN derived_class_cd d ON u.NISS_APRM_DETL_SK = d.NISS_APRM_DETL_SK