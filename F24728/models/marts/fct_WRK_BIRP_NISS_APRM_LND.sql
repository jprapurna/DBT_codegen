-- Purpose: Final model for reporting and analytics on NISS APRM LND data
SELECT
    {{ dbt_utils.surrogate_key(['NISS_APRM_LND_SK']) }} AS NISS_APRM_LND_SK,
    REG_PER_YR,
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
    ANNL_STMNT_LOB_CD,
    CVG_TYP_IND,
    CVG_EXPS_VAL,
    TTL_WRITTN_PREM_AMT,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    EXPS_VAL_ROLLED,
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
    LOB
FROM {{ ref('int_WRK_BIRP_NISS_APRM_LND') }}

#### schema.yml
version: 2

models:
  - name: int_WRK_BIRP_NISS_APRM_LND
    columns:
      - name: NISS_APRM_LND_SK
        tests:
          - not_null
          - unique
      - name: REG_PER_YR
        tests:
          - not_null
      - name: FISC_PER_YR
        tests:
          - not_null
      - name: NAIC_CMPNY_CD
        tests:
          - not_null
      - name: NISS_CMPNY_CD
        tests:
          - not_null
      - name: ST_NM
        tests:
          - not_null
      - name: ST_CD
        tests:
          - not_null
      - name: NISS_ST_CD
        tests:
          - not_null
      - name: ST_ABBR
        tests:
          - not_null
      - name: ACCTNG_LOB
        tests:
          - not_null
      - name: CVG_TYP_CD
        tests:
          - not_null
      - name: CVG_AMT
        tests:
          - not_null
      - name: BI_LMT
        tests:
          - not_null
      - name: GA_ADDED_AT_FAULT_IND
        tests:
          - not_null
      - name: FA2_PLCY_IND
        tests:
          - not_null
      - name: UM_UMI_STACKING
        tests:
          - not_null
      - name: PIP_WVR_WL_IND
        tests:
          - not_null
      - name: PIP_MED_SEC_IND
        tests:
          - not_null
      - name: PIP_LOSS_INCOME_IND
        tests:
          - not_null
      - name: MI_PPO_IND
        tests:
          - not_null
      - name: PRD_GRP_CD
        tests:
          - not_null
      - name: NJ_HLTH_INSR_PRIM
        tests:
          - not_null
      - name: NJ_EXTR_PIP_PKG
        tests:
          - not_null
      - name: NJ_RESDNC_RLTNSHP_PIP_IND
        tests:
          - not_null
      - name: NY_SSL_IND
        tests:
          - not_null
      - name: NY_FULL_CVG_GLASS_COMP_IND
        tests:
          - not_null
      - name: GRGNG_ZIP_5
        tests:
          - not_null
      - name: NISS_TERR_CD
        tests:
          - not_null
      - name: RATNG_CMPY_CD
        tests:
          - not_null
      - name: MLT_CAR_IND
        tests:
          - not_null
      - name: RT_CLS
        tests:
          - not_null
      - name: AGE
        tests:
          - not_null
      - name: GENDR
        tests:
          - not_null
      - name: MRTL_STAT
        tests:
          - not_null
      - name: AUTO_USE_CD
        tests:
          - not_null
      - name: MILES_TO_WRK
        tests:
          - not_null
      - name: GOOD_STDNT_IND
        tests:
          - not_null
      - name: DRVR_TRNG_IND
        tests:
          - not_null
      - name: SOI_TYP
        tests:
          - not_null
      - name: PHY_DMG_IND
        tests:
          - not_null
      - name: NJ_RATD_PNTS
        tests:
          - not_null
      - name: VEH_MDL_YR
        tests:
          - not_null
      - name: NJ_EXCPTION_CD
        tests:
          - not_null
      - name: NJ_FGVN_PNTS
        tests:
          - not_null
      - name: PASSV_RESTRA_DISC
        tests:
          - not_null
      - name: SNR_DRVR_IND
        tests:
          - not_null
      - name: DEFNS_DRVR_DISC_IND
        tests:
          - not_null
      - name: ANTI_THFT_DISC
        tests:
          - not_null
      - name: DAY_TM_RUN_LIGHTS
        tests:
          - not_null
      - name: LMT_TORT
        tests:
          - not_null
      - name: ANNL_STMNT_LOB_CD
        tests:
          - not_null
      - name: CVG_TYP_IND
        tests:
          - not_null
      - name: CVG_EXPS_VAL
        tests:
          - not_null
      - name: TTL_WRITTN_PREM_AMT
        tests:
          - not_null
      - name: CR_BY_MAPNG_ID
        tests:
          - not_null
      - name: DW_CR_TMSP
        tests:
          - not_null
      - name: UPD_BY_MAPNG_ID
        tests:
          - not_null
      - name: DW_UPD_TMSP
        tests:
          - not_null
      - name: WRK_FLOW_RUN_ID
        tests:
          - not_null
      - name: NJ_NO_LWST_LMT_IND
        tests:
          - not_null
      - name: NJ_NMD_DRVR_EXCL_IND
        tests:
          - not_null
      - name: EXPS_VAL_ROLLED
        tests:
          - not_null
      - name: COMP_DED
        tests:
          - not_null
      - name: COLL_DED
        tests:
          - not_null
      - name: PLCY_CNTRCT_NUM
        tests:
          - not_null
      - name: UNIT_NUM
        tests:
          - not_null
      - name: EFF_DT
        tests:
          - not_null
      - name: NUM_OF_CARS_IN_HH
        tests:
          - not_null
      - name: RDRVR_DT_OF_BRTH
        tests:
          - not_null
      - name: TERM_STRT_DT
        tests:
          - not_null
      - name: SRC_SYS_CD
        tests:
          - not_null
      - name: PNI_AGE
        tests:
          - not_null
      - name: LOB
        tests:
          - not_null

  - name: fct_WRK_BIRP_NISS_APRM_LND
    columns:
      - name: NISS_APRM_LND_SK
        tests:
          - not_null
          - unique
      - name: REG_PER_YR
        tests:
          - not_null
      - name: FISC_PER_YR
        tests:
          - not_null
      - name: NAIC_CMPNY_CD
        tests:
          - not_null
      - name: NISS_CMPNY_CD
        tests:
          - not_null
      - name: ST_NM
        tests:
          - not_null
      - name: ST_CD
        tests:
          - not_null
      - name: NISS_ST_CD
        tests:
          - not_null
      - name: ST_ABBR
        tests:
          - not_null
      - name: ACCTNG_LOB
        tests:
          - not_null
      - name: CVG_TYP_CD
        tests:
          - not_null
      - name: CVG_AMT
        tests:
          - not_null
      - name: BI_LMT
        tests:
          - not_null
      - name: GA_ADDED_AT_FAULT_IND
        tests:
          - not_null
      - name: FA2_PLCY_IND
        tests:
          - not_null
      - name: UM_UMI_STACKING
        tests:
          - not_null
      - name: PIP_WVR_WL_IND
        tests:
          - not_null
      - name: PIP_MED_SEC_IND
        tests:
          - not_null
      - name: PIP_LOSS_INCOME_IND
        tests:
          - not_null
      - name: MI_PPO_IND
        tests:
          - not_null
      - name: PRD_GRP_CD
        tests:
          - not_null
      - name: NJ_HLTH_INSR_PRIM
        tests:
          - not_null
      - name: NJ_EXTR_PIP_PKG
        tests:
          - not_null
      - name: NJ_RESDNC_RLTNSHP_PIP_IND
        tests:
          - not_null
      - name: NY_SSL_IND
        tests:
          - not_null
      - name: NY_FULL_CVG_GLASS_COMP_IND
        tests:
          - not_null
      - name: GRGNG_ZIP_5
        tests:
          - not_null
      - name: NISS_TERR_CD
        tests:
          - not_null
      - name: RATNG_CMPY_CD
        tests:
          - not_null
      - name: MLT_CAR_IND
        tests:
          - not_null
      - name: RT_CLS
        tests:
          - not_null
      - name: AGE
        tests:
          - not_null
      - name: GENDR
        tests:
          - not_null
      - name: MRTL_STAT
        tests:
          - not_null
      - name: AUTO_USE_CD
        tests:
          - not_null
      - name: MILES_TO_WRK
        tests:
          - not_null
      - name: GOOD_STDNT_IND
        tests:
          - not_null
      - name: DRVR_TRNG_IND
        tests:
          - not_null
      - name: SOI_TYP
        tests:
          - not_null
      - name: PHY_DMG_IND
        tests:
          - not_null
      - name: NJ_RATD_PNTS
        tests:
          - not_null
      - name: VEH_MDL_YR
        tests:
          - not_null
      - name: NJ_EXCPTION_CD
        tests:
          - not_null
      - name: NJ_FGVN_PNTS
        tests:
          - not_null
      - name: PASSV_RESTRA_DISC
        tests:
          - not_null
      - name: SNR_DRVR_IND
        tests:
          - not_null
      - name: DEFNS_DRVR_DISC_IND
        tests:
          - not_null
      - name: ANTI_THFT_DISC
        tests:
          - not_null
      - name: DAY_TM_RUN_LIGHTS
        tests:
          - not_null
      - name: LMT_TORT
        tests:
          - not_null
      - name: ANNL_STMNT_LOB_CD
        tests:
          - not_null
      - name: CVG_TYP_IND
        tests:
          - not_null
      - name: CVG_EXPS_VAL
        tests:
          - not_null
      - name: TTL_WRITTN_PREM_AMT
        tests:
          - not_null
      - name: CR_BY_MAPNG_ID
        tests:
          - not_null
      - name: DW_CR_TMSP
        tests:
          - not_null
      - name: UPD_BY_MAPNG_ID
        tests:
          - not_null
      - name: DW_UPD_TMSP
        tests:
          - not_null
      - name: WRK_FLOW_RUN_ID
        tests:
          - not_null
      - name: NJ_NO_LWST_LMT_IND
        tests:
          - not_null
      - name: NJ_NMD_DRVR_EXCL_IND
        tests:
          - not_null
      - name: EXPS_VAL_ROLLED
        tests:
          - not_null
      - name: COMP_DED
        tests:
          - not_null
      - name: COLL_DED
        tests:
          - not_null
      - name: PLCY_CNTRCT_NUM
        tests:
          - not_null
      - name: UNIT_NUM
        tests:
          - not_null
      - name: EFF_DT
        tests:
          - not_null
      - name: NUM_OF_CARS_IN_HH
        tests:
          - not_null
      - name: RDRVR_DT_OF_BRTH
        tests:
          - not_null
      - name: TERM_STRT_DT
        tests:
          - not_null
      - name: SRC_SYS_CD
        tests:
          - not_null
      - name: PNI_AGE
        tests:
          - not_null
      - name: LOB
        tests:
          - not_null