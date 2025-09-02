{{ config(materialized='view') }}

WITH niss_aprm_detail AS (
    SELECT
        "NISS_APRM_DETL_SK" AS niss_aprm_detl_sk, -- Primary key for NISS APRM detail
        "CLNDR_YR" AS clndr_yr, -- Calendar year
        "CALL_YR" AS call_yr, -- Call year
        "NAIC_CMPNY_CD" AS naic_cmpny_cd, -- NAIC company code
        "NISS_CMPNY_CD" AS niss_cmpny_cd, -- NISS company code
        "ST_NM" AS st_nm, -- State name
        "ST_CD" AS st_cd, -- State code
        "NISS_ST_CD" AS niss_st_cd, -- NISS state code
        "ST_ABBR" AS st_abbr, -- State abbreviation
        "ACCTNG_LOB" AS acctng_lob, -- Accounting line of business
        "CVG_TYP_CD" AS cvg_typ_cd, -- Coverage type code
        "CVG_AMT" AS cvg_amt, -- Coverage amount
        "BI_LMT" AS bi_lmt, -- BI limit
        "GA_ADDED_AT_FAULT_IND" AS ga_added_at_fault_ind, -- Georgia added at fault indicator
        "FA2_PLCY_IND" AS fa2_plcy_ind, -- FA2 policy indicator
        "UM_UMI_STACKING" AS um_umi_stacking, -- UM/UMI stacking
        "PIP_WVR_WL_IND" AS pip_wvr_wl_ind, -- PIP waiver indicator
        "PIP_MED_SEC_IND" AS pip_med_sec_ind, -- PIP medical section indicator
        "PIP_LOSS_INCOME_IND" AS pip_loss_income_ind, -- PIP loss income indicator
        "MI_PPO_IND" AS mi_ppo_ind, -- Michigan PPO indicator
        "PRD_GRP_CD" AS prd_grp_cd, -- Product group code
        "NJ_HLTH_INSR_PRIM" AS nj_hlth_insr_prim, -- New Jersey health insurance primary
        "NJ_EXTR_PIP_PKG" AS nj_extr_pip_pkg, -- New Jersey extra PIP package
        "NJ_RESDNC_RLTNSHP_PIP_IND" AS nj_resdnc_rltnshp_pip_ind, -- New Jersey residence relationship PIP indicator
        "NY_SSL_IND" AS ny_ssl_ind, -- New York SSL indicator
        "NY_FULL_CVG_GLASS_COMP_IND" AS ny_full_cvg_glass_comp_ind, -- New York full coverage glass comprehensive indicator
        "GRGNG_ZIP_5" AS grgng_zip_5, -- Garage ZIP code (5 digits)
        "NISS_TERR_CD" AS niss_terr_cd, -- NISS territory code
        "RATNG_CMPY_CD" AS ratng_cmpy_cd, -- Rating company code
        "MLT_CAR_IND" AS mlt_car_ind, -- Multi-car indicator
        "RT_CLS" AS rt_cls, -- Rating class
        "AGE" AS age, -- Age
        "GENDR" AS gendr, -- Gender
        "MRTL_STAT" AS mrtl_stat, -- Marital status
        "AUTO_USE_CD" AS auto_use_cd, -- Auto use code
        "MILES_TO_WRK" AS miles_to_wrk, -- Miles to work
        "GOOD_STDNT_IND" AS good_stdnt_ind, -- Good student indicator
        "DRVR_TRNG_IND" AS drvr_trng_ind, -- Driver training indicator
        "SOI_TYP" AS soi_typ, -- SOI type
        "PHY_DMG_IND" AS phy_dmg_ind, -- Physical damage indicator
        "NJ_RATD_PNTS" AS nj_ratd_pnts, -- New Jersey rated points
        "VEH_MDL_YR" AS veh_mdl_yr, -- Vehicle model year
        "NJ_EXCPTION_CD" AS nj_excption_cd, -- New Jersey exception code
        "NJ_FGVN_PNTS" AS nj_fgvn_pnts, -- New Jersey forgiven points
        "PASSV_RESTRA_DISC" AS passv_restra_disc, -- Passive restraint discount
        "SNR_DRVR_IND" AS snr_drvr_ind, -- Senior driver indicator
        "DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind, -- Defensive driver discount indicator
        "ANTI_THFT_DISC" AS anti_thft_disc, -- Anti-theft discount
        "DAY_TM_RUN_LIGHTS" AS day_tm_run_lights, -- Daytime running lights
        "LMT_TORT" AS lmt_tort, -- Limited tort
        "ANNL_STMNT_LOB_CD" AS annl_stmnt_lob_cd, -- Annual statement line of business code
        "CVG_TYP_IND" AS cvg_typ_ind, -- Coverage type indicator
        "CVG_EXPS_VAL" AS cvg_exps_val, -- Coverage expense value
        "TTL_WRITTN_PREM_AMT" AS ttl_writtn_prem_amt, -- Total written premium amount
        "LINE_CD" AS line_cd, -- Line code
        "ACCDNT_YR" AS accdnt_yr, -- Accident year
        "NISS_CVG_CD" AS niss_cvg_cd, -- NISS coverage code
        "RTNG_ZNE_CD" AS rtng_zne_cd, -- Rating zone code
        "TERM_ZNE_CD" AS term_zne_cd, -- Term zone code
        "NISS_CLASS_CD" AS niss_class_cd, -- NISS class code
        "NISS_ELIG_PNTS_CD" AS niss_elig_pnts_cd, -- NISS eligible points code
        "NISS_AGE_GRP_CD" AS niss_age_grp_cd, -- NISS age group code
        "NISS_CMMCL_IND_CD" AS niss_cmmcl_ind_cd, -- NISS commercial indicator code
        "NISS_EXCPN_CD" AS niss_excpn_cd, -- NISS exception code
        "NISS_FGVNS_CD" AS niss_fgvns_cd, -- NISS forgiven code
        "NISS_PASSV_RESTRA_CD" AS niss_passv_restra_cd, -- NISS passive restraint code
        "NISS_DEFNS_DRVR_CRD_CD" AS niss_defns_drvr_crd_cd, -- NISS defensive driver credit code
        "NISS_ANTI_THFT_DVC_CD" AS niss_anti_thft_dvc_cd, -- NISS anti-theft device code
        "NISS_DAY_TM_RUN_LAMPS_DISC_CD" AS niss_day_tm_run_lamps_disc_cd, -- NISS daytime running lamps discount code
        "NISS_PLCY_LMT_CD" AS niss_plcy_lmt_cd, -- NISS policy limit code
        "NISS_DEDUC_CD" AS niss_deduc_cd, -- NISS deductible code
        "NISS_SSL_LIAB_CD" AS niss_ssl_liab_cd, -- NISS SSL liability code
        "NISS_SUBLOB_CD" AS niss_sublob_cd, -- NISS sub-line of business code
        "NISS_TYP_LOSS_CD" AS niss_typ_loss_cd, -- NISS type loss code
        "NISS_LIAB_OR_NO_FAULT_CD" AS niss_liab_or_no_fault_cd, -- NISS liability or no-fault code
        "NISS_ANNL_STMNT_LOB_CD" AS niss_annl_stmnt_lob_cd, -- NISS annual statement line of business code
        "NISS_PD_LOSS" AS niss_pd_loss, -- NISS paid loss
        "NISS_PD_ALLOC_ADJUS_EXPNS" AS niss_pd_alloc_adj_expns, -- NISS paid allocated adjustment expense
        "NISS_OUTSTNDG_LOSS" AS niss_outstndg_loss, -- NISS outstanding loss
        "NISS_NO_PD_CLMS" AS niss_no_pd_clms, -- NISS number of paid claims
        "NISS_NO_OUTSTND_CLMS" AS niss_no_outstnd_clms, -- NISS number of outstanding claims
        "RSVD_NISS_USE" AS rsvd_niss_use, -- Reserved NISS use
        "NISS_RSVD_CMPNY_USE" AS niss_rsvd_cmpny_use, -- NISS reserved company use
        "NISS_MNFCTRS_MDL_YR" AS niss_mnfctrs_mdl_yr, -- NISS manufacturers model year
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID
        "NJ_NO_LWST_LMT_IND" AS nj_no_lwst_lmt_ind, -- New Jersey no lowest limit indicator
        "NJ_NMD_DRVR_EXCL_IND" AS nj_nmd_drvr_excl_ind, -- New Jersey named driver exclusion indicator
        "EXPS_VAL_ROLLED" AS exps_val_rolled, -- Expense value rolled
        "CVG_CNT_IND" AS cvg_cnt_ind, -- Coverage count indicator
        "CVG_CNT" AS cvg_cnt, -- Coverage count
        "CVG_CD_SK" AS cvg_cd_sk, -- Coverage code SK
        "CVG_ATTR_SK" AS cvg_attr_sk, -- Coverage attribute SK
        "REC_DROP_IND" AS rec_drop_ind, -- Record drop indicator
        "REC_DROP_RSN_DESC" AS rec_drop_rsn_desc, -- Record drop reason description
        "REC_EXCPN_IND" AS rec_excpn_ind, -- Record exception indicator
        "REC_EXCPN_RSN_DESC" AS rec_excpn_rsn_desc, -- Record exception reason description
        "CVG_ATTR_CHCKSUM" AS cvg_attr_chcksum, -- Coverage attribute checksum
        "COMP_DED" AS comp_ded, -- Comprehensive deductible
        "COLL_DED" AS coll_ded, -- Collision deductible
        "PLCY_CNTRCT_NUM" AS plcy_cntrct_num, -- Policy contract number
        "UNIT_NUM" AS unit_num, -- Unit number
        "EFF_DT" AS eff_dt, -- Effective date
        "NUM_OF_CARS_IN_HH" AS num_of_cars_in_hh, -- Number of cars in household
        "RDRVR_DT_OF_BRTH" AS rdrvr_dt_of_brth, -- Rated driver date of birth
        "TERM_STRT_DT" AS term_strt_dt, -- Term start date
        "SRC_SYS_CD" AS src_sys_cd, -- Source system code
        "DERIVED_RDRVR_AGE" AS derived_rdrvr_age, -- Derived rated driver age
        "FINAL_RDRVR_AGE" AS final_rdrvr_age, -- Final rated driver age
        "PNI_AGE" AS pni_age, -- Policyholder age
        "LOB" AS lob, -- Line of business
        "PRINCIPAL_OPRT" AS principal_oprt, -- Principal operator
        "SOURCE_IND_DERIVED" AS source_ind_derived -- Source indicator derived
    FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT
    niss_aprm_detl_sk,
    clndr_yr,
    call_yr,
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
    ratng_cmpy_cd,
    mlt_car_ind,
    rt_cls,
    age,
    gendr,
    mrtl_stat,
    auto_use_cd,
    miles_to_wrk,
    good_stdnt_ind,
    drvr_trng_ind,
    soi_typ,
    phy_dmg_ind,
    nj_ratd_pnts,
    veh_mdl_yr,
    nj_excption_cd,
    nj_fgvn_pnts,
    passv_restra_disc,
    snr_drvr_ind,
    defns_drvr_disc_ind,
    anti_thft_disc,
    day_tm_run_lights,
    lmt_tort,
    annl_stmnt_lob_cd,
    cvg_typ_ind,
    cvg_exps_val,
    ttl_writtn_prem_amt,
    line_cd,
    accdnt_yr,
    niss_cvg_cd,
    rtng_zne_cd,
    term_zne_cd,
    niss_class_cd,
    niss_elig_pnts_cd,
    niss_age_grp_cd,
    niss_cmmcl_ind_cd,
    niss_excpn_cd,
    niss_fgvns_cd,
    niss_passv_restra_cd,
    niss_defns_drvr_crd_cd,
    niss_anti_thft_dvc_cd,
    niss_day_tm_run_lamps_disc_cd,
    niss_plcy_lmt_cd,
    niss_deduc_cd,
    niss_ssl_liab_cd,
    niss_sublob_cd,
    niss_typ_loss_cd,
    niss_liab_or_no_fault_cd,
    niss_annl_stmnt_lob_cd,
    niss_pd_loss,
    niss_pd_alloc_adj_expns,
    niss_outstndg_loss,
    niss_no_pd_clms,
    niss_no_outstnd_clms,
    rsvd_niss_use,
    niss_rsvd_cmpny_use,
    niss_mnfctrs_mdl_yr,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id,
    nj_no_lwst_lmt_ind,
    nj_nmd_drvr_excl_ind,
    exps_val_rolled,
    cvg_cnt_ind,
    cvg_cnt,
    cvg_cd_sk,
    cvg_attr_sk,
    rec_drop_ind,
    rec_drop_rsn_desc,
    rec_excpn_ind,
    rec_excpn_rsn_desc,
    cvg_attr_chcksum,
    comp_ded,
    coll_ded,
    plcy_cntrct_num,
    unit_num,
    eff_dt,
    num_of_cars_in_hh,
    rdrvr_dt_of_brth,
    term_strt_dt,
    src_sys_cd,
    derived_rdrvr_age,
    final_rdrvr_age,
    pni_age,
    lob,
    principal_oprt,
    source_ind_derived
FROM niss_aprm_detail