-- Purpose: This model represents the expression transformation logic applied in the mapping 'm_NU0C_NISS_AUTO_ATPRM_DTL_PostSQL_Upd_Dummy'. It processes fields with direct expressions, maintaining input/output consistency.

WITH expression_transformation AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
  FROM {{ source('WRK_BIRP_NISS_APRM_DETL', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  NISS_APRM_DETL_SK,
  ST_ABBR,
  ACCTNG_LOB,
  BI_LMT,
  PRD_GRP_CD,
  NJ_NO_LWST_LMT_IND,
  NJ_NMD_DRVR_EXCL_IND,
  CVG_TYP_CD
FROM expression_transformation