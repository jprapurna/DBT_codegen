-- Purpose: This expression is used to derive TERR_CD and pass the data to target.

WITH derived_values AS (
  SELECT
    ROW_NUMBER() OVER() AS v_CNT,
    detl.NISS_ATPRM_LND_SK,
    detl.REG_PER_YR,
    detl.FISC_PER_YR,
    detl.NAIC_CMPNY_CD,
    detl.NISS_CMPNY_CD,
    detl.ST_NM,
    detl.ST_CD,
    detl.NISS_STATE_CODE,
    detl.STATE_ABBR,
    detl.ACCTNG_LOB,
    detl.CVG_TYP_CD,
    detl.CVG_AMT,
    detl.BI_LMT,
    detl.GA_ADDED_AT_FAULT_IND,
    detl.FA2_PLCY_IND,
    detl.UM_UIM_STACKING,
    detl.PIP_WVR_WL_IND,
    detl.PIP_MED_SEC_IND,
    detl.PIP_LOSS_INCOME_IND,
    detl.MI_PPO_IND,
    detl.PRD_GRP_CD,
    detl.NJ_HLTH_INSR_PRIM,
    detl.NJ_EXTR_PIP_PKG,
    detl.NJ_RESDNC_RLTNSHP_PIP_IND,
    detl.NY_SSL_IND,
    detl.NY_FULL_CVG_GLASS_COMP_IND,
    detl.GRGNG_ZIP_5,
    detl.i_NISS_TERR_CD,
    DECODE(1, ISNULL(detl.i_NISS_TERR_CD),'?', IS_SPACES(detl.i_NISS_TERR_CD),'?', LTRIM(RTRIM(detl.i_NISS_TERR_CD))) AS NISS_TERR_CD,
    detl.RATNG_CMPY_CD,
    detl.MLT_CAR_IND,
    detl.RT_CLS,
    detl.AGE,
    detl.GENDR,
    detl.MRTL_STAT,
    detl.AUTO_USE_CD
  FROM
    {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }} AS detl
)

SELECT
  dv.*
FROM
  derived_values AS dv