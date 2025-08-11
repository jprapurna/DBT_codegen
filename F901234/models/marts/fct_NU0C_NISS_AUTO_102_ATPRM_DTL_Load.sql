-- Purpose: Final model for loading ATPRM details

WITH territory_lookup AS (
  SELECT 
    REF_AUTO_TERR_SK,
    END_EFF_DT,
    CHCKSUM,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID,
    NISS_TERR_CD,
    CNTY_NM,
    CITY_NM,
    SRC_EFF_DT,
    SRC_OBSLT_DT
  FROM 
    {{ ref('int_LKP_RBI_REF_AUTO_TERR_ByStZipLob') }}
),

audit_id_lookup AS (
  SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    WRK_FLOW_RUN_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP
  FROM 
    {{ ref('int_EXP_ABC_MAPPING_AUDIT_ID_LOOKUP') }}
),

expression_transformation AS (
  SELECT 
    FISC_PER_YR,
    NAIC_CMPNY_CD,
    NISS_CMPNY_CD,
    ST_NM,
    ST_CD,
    NISS_ST_CD,
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
    PRD_GRP_CD,
    NJ_HLTH_INSR_PRIM,
    NJ_EXTR_PIP_PKG,
    NJ_RESDNC_RLTNSHP_PIP_IND,
    NY_SSL_IND,
    NY_FULL_CVG_GLASS_COMP_IND,
    GRGNG_ZIP_5,
    NISS_TERR_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND
  FROM 
    {{ ref('int_EXPTRANS') }}
)

SELECT 
  expression_transformation.FISC_PER_YR,
  expression_transformation.NAIC_CMPNY_CD,
  expression_transformation.NISS_CMPNY_CD,
  expression_transformation.ST_NM,
  expression_transformation.ST_CD,
  expression_transformation.NISS_ST_CD,
  expression_transformation.ST_ABBR,
  expression_transformation.ACCTNG_LOB,
  expression_transformation.CVG_TYP_CD,
  expression_transformation.CVG_AMT,
  expression_transformation.BI_LMT,
  expression_transformation.GA_ADDED_AT_FAULT_IND,
  expression_transformation.FA2_PLCY_IND,
  expression_transformation.UM_UMI_STACKING,
  expression_transformation.PIP_WVR_WL_IND,
  expression_transformation.PIP_MED_SEC_IND,
  expression_transformation.PIP_LOSS_INCOME_IND,
  expression_transformation.MI_PPO_IND,
  expression_transformation.PRD_GRP_CD,
  expression_transformation.NJ_HLTH_INSR_PRIM,
  expression_transformation.NJ_EXTR_PIP_PKG,
  expression_transformation.NJ_RESDNC_RLTNSHP_PIP_IND,
  expression_transformation.NY_SSL_IND,
  expression_transformation.NY_FULL_CVG_GLASS_COMP_IND,
  expression_transformation.GRGNG_ZIP_5,
  expression_transformation.NISS_TERR_CD,
  expression_transformation.RATNG_CMPY_CD,
  expression_transformation.MLT_CAR_IND,
  territory_lookup.REF_AUTO_TERR_SK,
  territory_lookup.END_EFF_DT,
  territory_lookup.CHCKSUM,
  territory_lookup.CR_BY_MAPNG_ID,
  territory_lookup.DW_CR_TMSP,
  territory_lookup.UPD_BY_MAPNG_ID,
  territory_lookup.DW_UPD_TMSP,
  territory_lookup.WRK_FLOW_RUN_ID,
  territory_lookup.NISS_TERR_CD,
  territory_lookup.CNTY_NM,
  territory_lookup.CITY_NM,
  territory_lookup.SRC_EFF_DT,
  territory_lookup.SRC_OBSLT_DT,
  audit_id_lookup.CR_BY_MAPNG_ID,
  audit_id_lookup.WRK_FLOW_RUN_ID,
  audit_id_lookup.DW_CR_TMSP,
  audit_id_lookup.UPD_BY_MAPNG_ID,
  audit_id_lookup.DW_UPD_TMSP
FROM 
  expression_transformation
JOIN 
  territory_lookup ON expression_transformation.NISS_TERR_CD = territory_lookup.NISS_TERR_CD
JOIN 
  audit_id_lookup ON expression_transformation.FISC_PER_YR = audit_id_lookup.FISC_PER_YR