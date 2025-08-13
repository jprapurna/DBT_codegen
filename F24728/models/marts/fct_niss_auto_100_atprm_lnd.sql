-- Purpose: Reporting and analytics for NISS auto data.
SELECT 
    {{ dbt_utils.surrogate_key(['REG_PER_YR', 'FISC_PER_YR', 'NAIC_CMPNY_CD', 'ST_NM', 'ST_CD']) }} AS niss_auto_100_atprm_lnd_sk,
    int.REG_PER_YR,
    int.FISC_PER_YR,
    int.NAIC_CMPNY_CD,
    int.ST_NM,
    int.ST_CD,
    int.ACCTNG_LOB,
    int.CVG_TYP_CD,
    int.CVG_AMT,
    int.BI_LMT,
    int.GA_UMBI_PD_ADDED_IND,
    int.FA2_PLCY_IND,
    int.UM_UIM_STACKING,
    int.PIP_WVR_WL_IND,
    int.PIP_MED_SEC_IND,
    int.PIP_LOSS_INCOME_IND,
    int.MI_PPO_IND,
    int.PRD_GRP_CD,
    int.NJ_HLTH_INSR_PRIM,
    int.NJ_EXTR_PIP_PKG,
    int.NJ_RESDNC_RLTNSHP_PIP_IND,
    int.NY_SSL_IND,
    int.NY_FULL_CVG_GLASS_COMP_IND,
    int.GRGNG_ZIP_5,
    int.RATNG_CMPY_CD,
    int.MLT_CAR_IND,
    int.RT_CLS,
    int.AGE,
    int.GENDR,
    int.MRTL_STAT,
    int.AUTO_USE_CD,
    int.MILES_TO_WRK,
    int.GOOD_STDNT_IND,
    int.DRVR_TRNG_IND,
    int.SOI_TYP,
    int.PHY_DMG_IND,
    int.NJ_RTD_PNTS,
    int.VEH_MDL_YR,
    int.NJ_EXCPTION_CD,
    int.NJ_FRGVN_PNTS,
    int.PASSV_RESTRA_DISC,
    int.SNR_DRVR_IND,
    int.DEFNS_DRVR_DISC_IND,
    int.ANTI_THFT_DISC,
    int.DAY_TM_RUN_LIGHTS,
    int.LMT_TORT,
    int.CVG_TYP_IND,
    int.CVG_EXPS_VAL,
    int.TTL_WRITTN_PREM_AMT,
    int.v_FARMERS_STATE_CD,
    int.IFARMERS_STATE_CD,
    int.NJ_NO_LWST_LMT_IND,
    int.NJ_NMD_DRVR_EXCL_IND,
    int.FARMERS_STATE_NAME,
    int.NISS_STATE_CODE,
    int.NISS_TERR_CD
FROM {{ ref('int_niss_auto_100_atprm_lnd') }} AS int

#### schema.yml
version: 2

models:
  - name: int_niss_auto_100_atprm_lnd
    description: Intermediate transformation for NISS auto data.
    columns:
      - name: NISS_TERR_CD
        description: Territory code derived using decode_null_spaces macro.
        tests:
          - not_null

  - name: fct_niss_auto_100_atprm_lnd
    description: Reporting and analytics for NISS auto data.
    columns:
      - name: FARMERS_STATE_NAME
        description: State name derived from state_codes.csv.
        tests:
          - not_null
          - unique
      - name: NISS_STATE_CODE
        description: State code derived from state_codes.csv.
        tests:
          - not_null
          - unique

seeds:
  - name: state_codes
    description: Encodes mapping of state names to state codes.
    columns:
      - name: FARMERS_STATE_NAME
        description: State name.
        tests:
          - not_null
          - unique
      - name: NISS_STATE_CODE
        description: State code.
        tests:
          - not_null
          - unique