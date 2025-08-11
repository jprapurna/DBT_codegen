-- Purpose: This model passes through various fields without modification.

SELECT
  NISS_APRM_DETL_SK,
  ST_NM,
  ST_ABBR,
  ACCTNG_LOB,
  CVG_TYP_CD,
  CVG_AMT,
  BI_LMT,
  GA_ADDED_AT_FAULT_IND,
  FA2_PLCY_IND,
  UM_UMI_STACKING,
  PIP_WVR_WL_IND,
  PIP_MED_SEC_IND,
  PIP_LOSS_INCOME_IND,
  MI_PPO_IND,
  COMP_DED,
  RATNG_CMPY_CD,
  COLL_DED,
  MIS_LOB,
  SOURCE_IND_DERIVED
FROM {{ ref('stg_wrk_birp_niss_aprm_detl') }}