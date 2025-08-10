-- Purpose: Load detailed data for NISS auto territory reporting

WITH detailed_data AS (
    SELECT 
        FISC_PER_YR AS fisc_per_yr,
        NAIC_CMPNY_CD AS naic_cmpny_cd,
        NISS_CMPNY_CD AS niss_cmpny_cd,
        ST_NM AS st_nm,
        ST_CD AS st_cd,
        NISS_ST_CD AS niss_st_cd,
        ST_ABBR AS st_abbr,
        ACCTNG_LOB AS acctng_lob,
        CVG_TYP_CD AS cvg_typ_cd,
        CVG_AMT AS cvg_amt,
        BI_LMT AS bi_lmt,
        GA_ADDED_AT_FAULT_IND AS ga_added_at_fault_ind,
        FA2_PLCY_IND AS fa2_plcy_ind,
        UM_UMI_STACKING AS um_umi_stacking,
        PIP_WVR_WL_IND AS pip_wvr_wl_ind,
        PIP_MED_SEC_IND AS pip_med_sec_ind,
        PIP_LOSS_INCOME_IND AS pip_loss_income_ind,
        MI_PPO_IND AS mi_ppo_ind,
        PRD_GRP_CD AS prd_grp_cd,
        NJ_HLTH_INSR_PRIM AS nj_hlth_insr_prim,
        NJ_EXTR_PIP_PKG AS nj_extr_pip_pkg,
        NJ_RESDNC_RLTNSHP_PIP_IND AS nj_resdnc_rltnshp_pip_ind,
        NY_SSL_IND AS ny_ssl_ind,
        NY_FULL_CVG_GLASS_COMP_IND AS ny_full_cvg_glass_comp_ind,
        GRGNG_ZIP_5 AS grgng_zip_5,
        NISS_TERR_CD AS niss_terr_cd,
        RATNG_CMPY_CD AS ratng_cmpny_cd,
        MLT_CAR_IND AS mlt_car_ind,
        WRK_FLOW_RUN_ID AS wrk_flow_run_id
    FROM {{ ref('int_LKP_RBI_REF_AUTO_TERR_ByStZipLob') }}
    JOIN {{ ref('int_EXP_ABC_MAPPING_AUDIT_ID_LOOKUP') }} ON ...
    JOIN {{ ref('int_EXPTRANS') }} ON ...
)

SELECT 
    fisc_per_yr,
    naic_cmpny_cd,
    niss_cmpny_cd,
    st_nm,
    st_cd,
    niss_st_cd,
    st_abbr,
    acctng_lob,
    cvg_typ_cd,
    cvg_amt,
    bi_lmt,
    ga_added_at_fault_ind,
    fa2_plcy_ind,
    um_umi_stacking,
    pip_wvr_wl_ind,
    pip_med_sec_ind,
    pip_loss_income_ind,
    mi_ppo_ind,
    prd_grp_cd,
    nj_hlth_insr_prim,
    nj_extr_pip_pkg,
    nj_resdnc_rltnshp_pip_ind,
    ny_ssl_ind,
    ny_full_cvg_glass_comp_ind,
    grgng_zip_5,
    niss_terr_cd,
    ratng_cmpny_cd,
    mlt_car_ind,
    wrk_flow_run_id
FROM detailed_data