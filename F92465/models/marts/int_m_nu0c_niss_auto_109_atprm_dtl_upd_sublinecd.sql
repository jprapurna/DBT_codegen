{{ config(materialized='ephemeral') }}

WITH source_data_1 AS (
  -- Source: FDR.WRK_BIRP_NISS_APRM_DETL (non NY/NJ)
  SELECT
    *,
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR NOT IN ('NY', 'NJ')
),

source_data_2 AS (
  -- Full source (not used below but kept if needed)
  SELECT
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

/* ---------- normalize & split BI_LMT ---------- */
EXP_BILimit_Split AS (
  SELECT
    sd.*,

    -- clean text
    REPLACE(TRIM(sd.BI_LMT), ',', '') AS v_BI_LMT,

    -- number of parts (how many "/" separators -> array size)
    ARRAY_SIZE(SPLIT(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/')) AS BI_LMT_NO_OF_PARTS,

    -- parts (safe even if missing parts)
    SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 1) AS v_Limit_FIELD1,
    SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 2) AS v_Limit_FIELD2,
    SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 3) AS v_Limit_FIELD3,

    -- numeric casts (NULL on non-numeric)
    TRY_CAST(SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 1) AS DECIMAL) AS BI_LMT_1_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 2) AS DECIMAL) AS BI_LMT_2_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(TRIM(sd.BI_LMT), ',', ''), '/', 3) AS DECIMAL) AS BI_LMT_3_Decimal,

    -- source cleaned
    REPLACE(TRIM(sd.BI_LMT), ',', '') AS SRC_BI_LMT

  FROM source_data_1 sd
),

/* ---------- derive sublob code & pass-thru ---------- */
EXP_Derive_NISS_SUBLOB_CD_And_PassThru AS (
  SELECT
    e.*,

    -- MI_PPO flag normalization
    CASE
      WHEN e.MI_PPO_IND = 1 THEN 'Y'
      WHEN e.MI_PPO_IND = 0 THEN 'N'
      ELSE ''
    END AS v_MI_PPO_IND,

    -- default placeholder
    CASE 
      WHEN e.ST_ABBR = 'NH' THEN '8'
      ELSE '?'
    END AS vv_NISS_SUBLOB_CD,

    /* Derived sublob for MI (example business logic)
       Uses SUBSTRING(string, start, length) and TERM_STRT_DT instead of EFF_DT */
    CASE
      WHEN e.ST_ABBR = 'MI'
       AND (SUBSTRING(TRIM(e.ACCTNG_LOB), 1, 3) = '191' OR TRIM(e.ACCTNG_LOB) = '191')
       AND COALESCE(e.TERM_STRT_DT, TO_DATE('1900-01-01')) >= TO_DATE('07/01/2020','MM/DD/YYYY')
    THEN
      CASE
        WHEN e.CVG_TYP_CD IN ('35000', '35082') AND COALESCE(e.BI_LMT_NO_OF_PARTS,0) = 1 AND COALESCE(e.BI_LMT_1_Decimal,0) > 0 THEN '2'
        WHEN e.CVG_TYP_CD IN ('35000', '35082') AND (COALESCE(e.SRC_BI_LMT,'') = '0' OR COALESCE(e.BI_LMT_NO_OF_PARTS,0) > 1) THEN '1'
        WHEN COALESCE(e.BI_LMT_NO_OF_PARTS,0) = 1 AND COALESCE(e.BI_LMT_1_Decimal,0) > 0 AND e.CVG_TYP_CD NOT IN ('35000', '35082') THEN '8'
        WHEN e.CVG_TYP_CD NOT IN ('35000', '35082') AND (COALESCE(e.SRC_BI_LMT,'') = '0' OR COALESCE(e.BI_LMT_NO_OF_PARTS,0) > 1) THEN '7'
        ELSE vv_NISS_SUBLOB_CD
      END
    ELSE vv_NISS_SUBLOB_CD
    END AS v_NISS_SUBLOB_CD,

    /* final cleanup */
    CASE
      WHEN COALESCE(v_NISS_SUBLOB_CD, '') = '' THEN '?'
      ELSE v_NISS_SUBLOB_CD
    END AS NISS_SUBLOB_CD

  FROM EXP_BILimit_Split e
),

/* ---------- output (keeps original columns + flags) ---------- */
UPD_NISS_SUBLOB_CD AS (
  SELECT
    *,
    'DD_UPDATE' AS update_strategy,
    -- keep original key and derived sublob in output
    NISS_APRM_DETL_SK,
    NISS_SUBLOB_CD
  FROM EXP_Derive_NISS_SUBLOB_CD_And_PassThru
)

SELECT * FROM UPD_NISS_SUBLOB_CD
