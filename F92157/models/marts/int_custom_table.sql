{{ config(materialized='table') }}

SELECT
  SQ.*,
  THEFT.ANTI_THFT_CTGY_CD AS anti_thft_ctgy_cd
FROM (
  SELECT
    CASE WHEN {{ var('run_type') }} = 'Register' THEN REG_PER_YR ELSE FISC_PER_YR END AS clndr_yr,
    NAIC_CMPNY_CD AS naic_cmpny_cd,
    NISS_CMPNY_CD AS niss_cmpny_cd,
    LTRIM(RTRIM(ST_NM)) AS st_nm,
    LTRIM(RTRIM(ST_CD)) AS st_cd,
    NISS_ST_CD AS niss_st_cd,
    LTRIM(RTRIM(ST_ABBR)) AS st_abbr,
    LTRIM(RTRIM(ACCTNG_LOB)) AS acctng_lob,
    LTRIM(RTRIM(CVG_TYP_CD)) AS cvg_typ_cd,
    LTRIM(RTRIM(CVG_AMT)) AS cvg_amt,
    LTRIM(RTRIM(BI_LMT)) AS bi_lmt,
    GA_ADDED_AT_FAULT_IND AS ga_added_at_fault_ind,
    FA2_PLCY_IND AS fa2_plcy_ind,
    UM_UMI_STACKING AS um_umi_stacking,
    PIP_WVR_WL_IND AS pip_wvr_wl_ind,
    PIP_MED_SEC_IND AS pip_med_sec_ind,
    PIP_LOSS_INCOME_IND AS pip_loss_income_ind,
    MI_PPO_IND AS mi_ppo_ind,
    LTRIM(RTRIM(PRD_GRP_CD)) AS prd_grp_cd,
    LTRIM(RTRIM(NJ_HLTH_INSR_PRIM)) AS nj_hlth_insr_prim,
    LTRIM(RTRIM(NJ_EXTR_PIP_PKG)) AS nj_extr_pip_pkg,
    NJ_RESDNC_RLTNSHP_PIP_IND AS nj_resdnc_rltnshp_pip_ind,
    NY_SSL_IND AS ny_ssl_ind,
    NY_FULL_CVG_GLASS_COMP_IND AS ny_full_cvg_glass_comp_ind,
    LTRIM(RTRIM(GRGNG_ZIP)) AS grgng_zip,
    NISS_TERR_CD AS niss_terr_cd,
    LTRIM(RTRIM(RATNG_CMPNY_CD)) AS ratng_cmpny_cd,
    LTRIM(RTRIM(MLT_CAR_IND)) AS mlt_car_ind,
    LTRIM(RTRIM(RT_CLS)) AS rt_cls,
    LTRIM(RTRIM(AGE)) AS age,
    LTRIM(RTRIM(GENDR)) AS gendr,
    LTRIM(RTRIM(MRTL_STAT)) AS mrtl_stat,
    LTRIM(RTRIM(AUTO_USE_CD)) AS auto_use_cd,
    LTRIM(RTRIM(MILES_TO_WRK)) AS miles_to_wrk,
    LTRIM(RTRIM(GOOD_STDNT_IND)) AS good_stdnt_ind,
    LTRIM(RTRIM(DRVR_TRNG_IND)) AS drvr_trng_ind,
    CASE WHEN NISS_ST_CD = '29' AND LTRIM(RTRIM(ACCTNG_LOB)) IN ('2110T', '2110F') THEN '01' ELSE LTRIM(RTRIM(SOI_TYP)) END AS soi_typ,
    PHY_DMG_IND AS phy_dmg_ind,
    NJ_RATD_PNTS AS nj_ratd_pnts,
    VEH_MDL_YR AS veh_mdl_yr,
    NJ_EXCPTION_CD AS nj_excption_cd,
    NJ_FGVN_PNTS AS nj_fgvn_pnts,
    PASSV_RESTRA_DISC AS passv_restra_disc,
    SNR_DRVR_IND AS snr_drvr_ind,
    DEFNS_DRVR_DISC_IND AS defns_drvr_disc_ind,
    ANTI_THFT_DISC AS anti_thft_disc,
    DAY_TM_RUN_LIGHTS AS day_tm_run_lights,
    LMT_TORT AS lmt_tort,
    ANNL_STMNT_LOB_CD AS annl_stmnt_lob_cd,
    CVG_TYP_IND AS cvg_typ_ind,
    CVG_EXPS_VAL AS cvg_exps_val,
    ROUND(TTL_WRITTN_PREM_AMT) AS ttl_writtn_prem_amt,
    NJ_NO_LWST_LMT_IND AS nj_no_lwst_lmt_ind,
    NJ_NMD_DRVR_EXCL_IND AS nj_nmd_drvr_excl_ind,
    COALESCE(LTRIM(RTRIM(COMP_DED)), '') AS comp_ded,
    COALESCE(LTRIM(RTRIM(COLL_DED)), '') AS coll_ded,
    LTRIM(RTRIM(PLCY_CNTRCT_NUM)) AS plcy_cntrct_num,
    UNIT_NUM AS unit_num,
    EFF_DT AS eff_dt,
    NUM_OF_CARS_IN_HH AS num_of_cars_in_hh,
    COALESCE(RDRVR_DT_OF_BRTH, '0') AS rdrvr_dt_of_brth,
    TERM_STRT_DT AS term_strt_dt,
    COALESCE(LTRIM(RTRIM(SRC_SYS_CD)), '') AS src_sys_cd,
    PNI_AGE AS pni_age,
    '' AS lob,
    '' AS principal_oprt,
    'FARMERS' AS source_ind_derived
  FROM {{ source('fdr', 'wrk_birp_niss_aprm_lnd') }}
) SQ
LEFT OUTER JOIN (
  SELECT DISTINCT
    A.ANTI_THFT_CTGY_CD AS anti_thft_ctgy_cd,
    A.PLCY_CNTRCT_NUM AS plcy_cntrct_num,
    A.UNIT_NUM AS unit_num,
    A.TERM_STRT_DT AS term_strt_dt
  FROM (
    SELECT
      PLCY.PLCY_CNTRCT_NUM AS plcy_cntrct_num,
      PLCY.TERM_STRT_DT AS term_strt_dt,
      SOI.UNIT_NUM AS unit_num,
      ASOI.ANTI_THFT_CTGY_CD AS anti_thft_ctgy_cd,
      ROW_NUMBER() OVER (PARTITION BY PLCY.PLCY_CNTRCT_NUM, PLCY.TERM_STRT_DT, SOI.UNIT_NUM ORDER BY ASOI.ANTI_THFT_CTGY_CD DESC) AS cnt1
    FROM {{ source('agdm', 'fact_ag_writtn_prem_cvg_lvl') }} FACT
    JOIN {{ source('agdm', 'dim_ag_plcy') }} PLCY ON FACT.PLCY_SK = PLCY.PLCY_SK
    JOIN {{ source('agdm', 'dim_ag_trans_typ_plcy') }} ON FACT.TRANS_TYP_PLCY_SK = {{ source('agdm', 'dim_ag_trans_typ_plcy') }}.TRANS_TYP_PLCY_SK
    JOIN {{ source('agdm', 'dim_ag_soi') }} SOI ON FACT.SOI_SK = SOI.SOI_SK
    JOIN {{ source('agdm', 'dim_ag_farmer_geo_distr') }} GEOD ON FACT.FARMR_GEO_DISTR_SK = GEOD.FARMR_GEO_DISTR_SK
    JOIN {{ source('agdm', 'dim_ag_farmer_geo_st') }} GEOS ON GEOD.FARMR_GEO_ST_SK = GEOS.FARMR_GEO_ST_SK
    JOIN {{ source('agdm', 'dim_dt') }} REGPER ON FACT.REGSTR_PER_SK = REGPER.DT_SK
    JOIN {{ source('agdm', 'dim_dt') }} FISCPER ON FACT.FISC_PER_SK = FISCPER.DT_SK
    LEFT OUTER JOIN {{ source('fdr', 'fdr_auto_soi') }} ASOI ON PLCY.PLCY_ID_SK = ASOI.PLCY_ID_SK AND SOI.UNIT_NUM = ASOI.UNIT_NUM AND PLCY.TERM_STRT_DT = ASOI.EFF_DT
    WHERE ASOI.ANTI_THFT_CTGY_CD IS NOT NULL
      AND TRIM(GEOS.ST_NM) IN ({{ var('geo_st_nm_bckp') }})
      AND FISCPER.CLNDR_YR = {{ var('rpt_year') }}
      AND {{ source('agdm', 'dim_ag_trans_typ_plcy') }}.TRANS_TYP_PLCY_CD NOT IN ('WO')
  ) A
  WHERE A.CNT1 = 1
) THEFT ON TRIM(THEFT.PLCY_CNTRCT_NUM) = TRIM(SQ.PLCY_CNTRCT_NUM)
  AND THEFT.UNIT_NUM = SQ.UNIT_NUM
  AND SQ.TERM_STRT_DT = THEFT.TERM_STRT_DT
WHERE {{ var('backendfix_dt') }} = {{ var('clndr_yr') }}
  AND LTRIM(RTRIM(NISS_CMPNY_CD)) NOT IN ('180')