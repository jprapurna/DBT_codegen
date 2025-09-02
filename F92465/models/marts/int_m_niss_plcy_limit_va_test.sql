{{
  config(materialized='view')
}}

WITH source_fdr_wrk_birp_niss_aprm_detl AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    NISS_CVG_CD
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR = 'VA'
),

source_wrk_birp_niss_aprm_detl AS (
  SELECT
    NISS_APRM_DETL_SK,
    CLNDR_YR,
    CALL_YR,
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
    LINE_CD,
    ACCDNT_YR,
    NISS_CVG_CD,
    RTNG_ZNE_CD,
    TERM_ZNE_CD,
    NISS_CLASS_CD,
    NISS_ELIG_PNTS_CD,
    NISS_AGE_GRP_CD,
    NISS_CMMCL_IND_CD,
    NISS_EXCPN_CD,
    NISS_FGVNS_CD,
    NISS_PASSV_RESTRA_CD,
    NISS_DEFNS_DRVR_CRD_CD,
    NISS_ANTI_THFT_DVC_CD,
    NISS_DAY_TM_RUN_LAMPS_DISC_CD,
    NISS_PLCY_LMT_CD,
    NISS_DEDUC_CD,
    NISS_SSL_LIAB_CD,
    NISS_SUBLOB_CD,
    NISS_TYP_LOSS_CD,
    NISS_LIAB_OR_NO_FAULT_CD,
    NISS_ANNL_STMNT_LOB_CD,
    NISS_PD_LOSS,
    NISS_PD_ALLOC_ADJUS_EXPNS,
    NISS_OUTSTNDG_LOSS,
    NISS_NO_PD_CLMS,
    NISS_NO_OUTSTND_CLMS,
    RSVD_NISS_USE,
    NISS_RSVD_CMPNY_USE,
    NISS_MNFCTRS_MDL_YR,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    EXPS_VAL_ROLLED,
    CVG_CNT_IND,
    CVG_CNT,
    CVG_CD_SK,
    CVG_ATTR_SK,
    REC_DROP_IND,
    REC_DROP_RSN_DESC,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC,
    CVG_ATTR_CHCKSUM,
    COMP_DED,
    COLL_DED,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    NUM_OF_CARS_IN_HH,
    RDRVR_DT_OF_BRTH,
    TERM_STRT_DT,
    SRC_SYS_CD,
    DERIVED_RDRVR_AGE,
    FINAL_RDRVR_AGE,
    PNI_AGE,
    LOB,
    PRINCIPAL_OPRT,
    SOURCE_IND_DERIVED
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

exp_passthru AS (
  SELECT
    *,
    NISS_ST_CD AS NISS_ST_CD1
  FROM source_fdr_wrk_birp_niss_aprm_detl
),

exp_cvgamount_split AS (
  SELECT
    *,
    REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', '') AS v_CVG_AMT,
    ARRAY_SIZE(SPLIT(v_CVG_AMT, '/')) AS v_CVG_AMT_Parts,

    -- safer splits instead of manual POSITION
    SPLIT_PART(v_CVG_AMT, '/', 1) AS v_AMOUNT_FIELD1,
    SPLIT_PART(v_CVG_AMT, '/', 2) AS v_AMOUNT_FIELD2,
    SPLIT_PART(v_CVG_AMT, '/', 3) AS v_AMOUNT_FIELD3,

    TRY_CAST(SPLIT_PART(v_CVG_AMT, '/', 1) AS DECIMAL) AS CVG_AMT_1_Decimal,
    TRY_CAST(SPLIT_PART(v_CVG_AMT, '/', 2) AS DECIMAL) AS CVG_AMT_2_Decimal,
    TRY_CAST(SPLIT_PART(v_CVG_AMT, '/', 3) AS DECIMAL) AS CVG_AMT_3_Decimal,

    v_CVG_AMT AS SRC_CVG_AMT
  FROM exp_passthru
),

exp_derive_niss_plcy_lmt_cd_and_passthru AS (
  SELECT
    *,
    CASE
      WHEN ST_ABBR = 'CT' THEN
        CASE
          WHEN ACCTNG_LOB = '192MD' THEN
            CASE
              WHEN CVG_AMT = '500' THEN '01'
              WHEN CVG_AMT = '750' THEN '02'
              WHEN CVG_AMT = '1,000' THEN '03'
              WHEN CVG_AMT = '2,000' THEN '04'
              WHEN CVG_AMT = '3,000' THEN '05'
              WHEN CVG_AMT = '5,000' THEN '06'
              WHEN CVG_AMT = '7,500' THEN '07'
              WHEN CVG_AMT_1_Decimal > 7500 THEN '08'
              ELSE '09'
            END
          WHEN ACCTNG_LOB = '192BI' THEN
            CASE
              WHEN CVG_TYP_CD IN ('13003', '13023', '40015', '13029', '40021', '13046', '13048') THEN
                CASE
                  WHEN CVG_AMT = '20,000/40,000' THEN '04'
                  WHEN CVG_AMT = '25,000/50,000' THEN '05'
                  WHEN CVG_AMT = '50,000/100,000' THEN '06'
                  WHEN CVG_AMT = '100,000/200,000' THEN '07'
                  WHEN CVG_AMT = '100,000/300,000' THEN '08'
                  WHEN CVG_AMT_1_Decimal > 100000 AND CVG_AMT_2_Decimal > 300000 THEN '09'
                  ELSE '01'
                END
              ELSE ''
            END
          ELSE ''
        END
      ELSE ''
    END AS v_NISS_PLCY_LMT_CD
  FROM exp_cvgamount_split
),

updtrans AS (
  SELECT
    *,
    v_NISS_PLCY_LMT_CD AS o_NISS_PLCY_LIMIT_CD_VA
  FROM exp_derive_niss_plcy_lmt_cd_and_passthru
)

SELECT * FROM updtrans