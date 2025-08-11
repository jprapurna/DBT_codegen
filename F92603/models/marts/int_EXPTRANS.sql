-- Purpose: This model represents the expression transformation logic applied to fields in the mapping 'm_NU0C_NISS_AUTO_ATPRM_DTL_PostSQL_Upd_Dummy'.

SELECT
  NISS_APRM_DETL_SK,
  ST_ABBR,
  ACCTNG_LOB,
  BI_LMT,
  PRD_GRP_CD,
  NJ_NO_LWST_LMT_IND,
  NJ_NMD_DRVR_EXCL_IND,
  CVG_TYP_CD
FROM {{ ref('FDR_LIB_WRK_BIRP_NISS_APRM_DETL') }}