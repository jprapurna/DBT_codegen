-- Purpose: Final model for reporting or analytics
WITH seqtrans AS (
  SELECT 
    nextval,
    currval
  FROM {{ ref('int_SEQTRANS') }}
),
lkp_ff_ref_niss_state_cd AS (
  SELECT 
    i_ST_NM,
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM {{ ref('int_LKP_ff_REF_NISS_STATE_CD') }}
),
lkp_ref_tfarmers_state AS (
  SELECT 
    FARMERS_STATE_CD,
    STATE_CODE
  FROM {{ ref('int_LKP_REF_TFARMERS_STATE') }}
),
lkp_rbi_ref_auto_terr_bystziplob AS (
  SELECT 
    i_NISS_ST_CD,
    i_ST_ABBRV,
    i_ZIP_CD,
    NISS_TERR_CD
  FROM {{ ref('int_LKP_RBI_REF_AUTO_TERR_ByStZipLob') }}
),
mplt_abc_mapping_audit AS (
  SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM {{ ref('int_mplt_ABC_MAPPING_AUDIT') }}
),
exp_pass_through AS (
  SELECT 
    REG_PER_YR,
    FISC_PER_YR,
    NAIC_CMPNY_CD,
    ST_NM,
    ST_CD,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    BI_LMT,
    GA_ADDED_AT_FAULT_IND,
    PLCY_IND,
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
    GRGNG_ZIP,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    RT_CLS,
    AGE,
    GENDR,
    MRTL_STAT,
    AUTO_USE_CD,
    MILES_TO_WRK,
    GOOD_STDNT_IND
  FROM {{ ref('int_EXP_PASS_THROUGH') }}
)
SELECT 
  seqtrans.nextval,
  seqtrans.currval,
  lkp_ff_ref_niss_state_cd.i_ST_NM,
  lkp_ff_ref_niss_state_cd.FARMERS_STATE_NAME,
  lkp_ff_ref_niss_state_cd.NISS_STATE_CODE,
  lkp_ref_tfarmers_state.FARMERS_STATE_CD,
  lkp_ref_tfarmers_state.STATE_CODE,
  lkp_rbi_ref_auto_terr_bystziplob.i_NISS_ST_CD,
  lkp_rbi_ref_auto_terr_bystziplob.i_ST_ABBRV,
  lkp_rbi_ref_auto_terr_bystziplob.i_ZIP_CD,
  lkp_rbi_ref_auto_terr_bystziplob.NISS_TERR_CD,
  mplt_abc_mapping_audit.MAPPING_NAME,
  mplt_abc_mapping_audit.FOLDER_NAME,
  mplt_abc_mapping_audit.WORKFLOW_NAME,
  mplt_abc_mapping_audit.CR_BY_MAPNG_ID,
  mplt_abc_mapping_audit.DW_CR_TMSP,
  mplt_abc_mapping_audit.UPD_BY_MAPNG_ID,
  mplt_abc_mapping_audit.DW_UPD_TMSP,
  mplt_abc_mapping_audit.WRK_FLOW_RUN_ID,
  exp_pass_through.REG_PER_YR,
  exp_pass_through.FISC_PER_YR,
  exp_pass_through.NAIC_CMPNY_CD,
  exp_pass_through.ST_NM,
  exp_pass_through.ST_CD,
  exp_pass_through.ACCTNG_LOB,
  exp_pass_through.CVG_TYP_CD,
  exp_pass_through.CVG_AMT,
  exp_pass_through.BI_LMT,
  exp_pass_through.GA_ADDED_AT_FAULT_IND,
  exp_pass_through.PLCY_IND,
  exp_pass_through.UM_UMI_STACKING,
  exp_pass_through.PIP_WVR_WL_IND,
  exp_pass_through.PIP_MED_SEC_IND,
  exp_pass_through.PIP_LOSS_INCOME_IND,
  exp_pass_through.MI_PPO_IND,
  exp_pass_through.PRD_GRP_CD,
  exp_pass_through.NJ_HLTH_INSR_PRIM,
  exp_pass_through.NJ_EXTR_PIP_PKG,
  exp_pass_through.NJ_RESDNC_RLTNSHP_PIP_IND,
  exp_pass_through.NY_SSL_IND,
  exp_pass_through.NY_FULL_CVG_GLASS_COMP_IND,
  exp_pass_through.GRGNG_ZIP,
  exp_pass_through.RATNG_CMPY_CD,
  exp_pass_through.MLT_CAR_IND,
  exp_pass_through.RT_CLS,
  exp_pass_through.AGE,
  exp_pass_through.GENDR,
  exp_pass_through.MRTL_STAT,
  exp_pass_through.AUTO_USE_CD,
  exp_pass_through.MILES_TO_WRK,
  exp_pass_through.GOOD_STDNT_IND
FROM seqtrans
JOIN lkp_ff_ref_niss_state_cd ON seqtrans.currval = lkp_ff_ref_niss_state_cd.i_ST_NM
JOIN lkp_ref_tfarmers_state ON lkp_ff_ref_niss_state_cd.FARMERS_STATE_NAME = lkp_ref_tfarmers_state.FARMERS_STATE_CD
JOIN lkp_rbi_ref_auto_terr_bystziplob ON lkp_ref_tfarmers_state.STATE_CODE = lkp_rbi_ref_auto_terr_bystziplob.i_NISS_ST_CD
JOIN mplt_abc_mapping_audit ON lkp_rbi_ref_auto_terr_bystziplob.NISS_TERR_CD = mplt_abc_mapping_audit.MAPPING_NAME
JOIN exp_pass_through ON mplt_abc_mapping_audit.WRK_FLOW_RUN_ID = exp_pass_through.REG_PER_YR