{{
  config(
    materialized='ephemeral'
  )
}}

WITH seqtrans AS (
  SELECT
    NEXTVAL('sequence_name') AS sequence_value,
    CURRVAL('sequence_name') AS current_value
),

exp_pass_through AS (
  SELECT
    *,
    -- Pass-through transformation for multiple fields
    UM_UMI_STACKING,
    PIP_WVR_WL_IND,
    PIP_MED_SEC_IND,
    PIP_LOSS_INCOME_IND,
    MI_PPO_IND,
    PRD_GRP_CD,
    NJ_HLTH_INSR_PRIM,
    NJ_EXTR_PIP_PKG,
    NJ_RESDNC_RLTNSHP_PIP_IND,
    NY_SSL_IND,
    NY_FULL_CVG_GLASS_COMP_IND,
    i_GRGNG_ZIP,
    GRGNG_ZIP_5,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    RT_CLS,
    AGE,
    GENDR,
    MRTL_STAT,
    AUTO_USE_CD,
    MILES_TO_WRK,
    GOOD_STDNT_IND,
    DRVR_TRNG_IND,
    SOI_TYP,
    PHY_DMG_IND,
    EXPS_VAL_ROLLED,
    NJ_RATD_PNTS,
    VEH_MDL_YR,
    NJ_EXCPTION_CD,
    NJ_FGVN_PNTS,
    PASSV_RESTRA_DISC,
    SNR_DRVR_IND,
    DEFNS_DRVR_DISC_IND,
    ANTI_THFT_DISC,
    DAY_TM_RUN_LIGHTS,
    LMT_TORT,
    CVG_TYP_IND,
    CVG_EXPS_VAL,
    WRITTN_PREM_AMT,
    i_ST_ABBR,
    ST_ABBR,
    NJ_NO_LWST_LMT_IND,
    IFARMERS_STATE_CD,
    NJ_NMD_DRVR_EXCL_IND,
    COMP_DED,
    COLL_DED,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    NUM_OF_CARS_IN_HH,
    RDRVR_DT_OF_BRTH,
    TERM_STRT_DT,
    SRC_SYS_CD,
    PNI_AGE,
    MIS_LOB,
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    PRINCIPAL_OPRT,
    SOURCE_IND_DERIVED,
    i_NISS_STATE_CODE,
    NISS_STATE_CODE,
    i_NISS_TERR_CD,
    NISS_TERR_CD,
    NISS_CMPNY_CD
  FROM seqtrans
),

exptrans1 AS (
  SELECT
    *,
    CASE 
      WHEN i_GA_ADDED_AT_FAULT_IND = '1' THEN 'Y'
      ELSE 'N'
    END AS GA_ADDED_AT_FAULT_IND
  FROM exp_pass_through
),

lkp_ff_ref_niss_state_cd AS (
  SELECT
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM {{ source('flat_file', 'ref_niss_state_cd') }}
  WHERE FARMERS_STATE_NAME = exptrans1.i_ST_NM
),

lkp_fdr_lib_ref_tfarmers_state AS (
  SELECT
    STATE_CODE
  FROM {{ source('fdr', 'ref_tfarmers_state') }}
  WHERE FARMERS_STATE_CD = exptrans1.i_FARMERS_STATE_CD
),

lkp_rbi_ref_auto_terr_bystziplob AS (
  SELECT
    REF.NISS_TERR_CD
  FROM {{ source('birp', 'rbi_ref_auto_terr') }} REF
  WHERE REF.END_EFF_DT = '2999-12-31'
),

exptrans2 AS (
  SELECT
    *,
    DECODE(1,
      ISNULL(i_NISS_TERR_CD), '?',
      IS_SPACES(i_NISS_TERR_CD), '?',
      LTRIM(RTRIM(i_NISS_TERR_CD))
    ) AS NISS_TERR_CD
  FROM exptrans1
),

final AS (
  SELECT
    *
  FROM exptrans2
)

SELECT * FROM final