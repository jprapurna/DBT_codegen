{{ config(materialized='view') }}

SELECT
"FISC_PER_YR" AS fisc_per_yr, -- Fiscal period year.
"NAIC_CMPNY_CD" AS naic_cmpny_cd, -- NAIC company code.
"NISS_CMPNY_CD" AS niss_cmpny_cd, -- NISS company code.
"ST_NM" AS st_nm, -- State name.
"ST_CD" AS st_cd, -- State code.
"NISS_ST_CD" AS niss_st_cd, -- NISS state code.
"ST_ABBR" AS st_abbr, -- State abbreviation.
"ACCTNG_LOB" AS acctng_lob, -- Accounting line of business.
"CVG_TYP_CD" AS cvg_typ_cd, -- Coverage type code.
"CVG_AMT" AS cvg_amt, -- Coverage amount.
"BI_LMT" AS bi_lmt, -- Bodily injury limit.
"GA_ADDED_AT_FAULT_IND" AS ga_added_at_fault_ind, -- GA added at fault indicator.
"PLCY_IND" AS plcy_ind, -- Policy indicator.
"UM_UMI_STACKING" AS um_umi_stacking, -- UM/UMI stacking indicator.
"PIP_WVR_WL_IND" AS pip_wvr_wl_ind, -- PIP waiver WL indicator.
"PIP_MED_SEC_IND" AS pip_med_sec_ind, -- PIP medical section indicator.
"PIP_LOSS_INCOME_IND" AS pip_loss_income_ind, -- PIP loss income indicator.
"MI_PPO_IND" AS mi_ppo_ind, -- MI PPO indicator.
"PRD_GRP_CD" AS prd_grp_cd, -- Product group code.
"NJ_HLTH_INSR_PRIM" AS nj_hlth_insr_prim, -- NJ health insurance primary indicator.
"NJ_EXTR_PIP_PKG" AS nj_extr_pip_pkg, -- NJ extra PIP package indicator.
"NJ_RESDNC_RLTNSHP_PIP_IND" AS nj_resdnc_rltnshp_pip_ind, -- NJ residence relationship PIP indicator.
"NY_SSL_IND" AS ny_ssl_ind, -- NY SSL indicator.
"NY_FULL_CVG_GLASS_COMP_IND" AS ny_full_cvg_glass_comp_ind, -- NY full coverage glass comp indicator.
"GRGNG_ZIP" AS grgng_zip, -- Garage zip code.
"NISS_TERR_CD" AS niss_terr_cd, -- NISS territory code.
"RATNG_CMPY_CD" AS ratng_cmpy_cd, -- Rating company code.
"MLT_CAR_IND" AS mlt_car_ind, -- Multi-car indicator.
"RT_CLS" AS rt_cls, -- Rate class.
"AGE" AS age, -- Age of the driver.
"GENDR" AS gendr, -- Gender of the driver.
"MRTL_STAT" AS mrtl_stat, -- Marital status of the driver.
"AUTO_USE_CD" AS auto_use_cd, -- Auto use code.
"MILES_TO_WRK" AS miles_to_wrk, -- Miles to work.
"GOOD_STDNT_IND" AS good_stdnt_ind, -- Good student indicator.
"DRVR_TRNG_IND" AS drvr_trng_ind, -- Driver training indicator.
"SOI_TYP" AS soi_typ, -- SOI type.
"PHY_DMG_IND" AS phy_dmg_ind, -- Physical damage indicator.
"NJ_RATD_PNTS" AS nj_ratd_pnts, -- NJ rated points.
"VEH_MDL_YR" AS veh_mdl_yr, -- Vehicle model year.
"NJ_EXCPTION_CD" AS nj_excption_cd, -- NJ exception code.
"NJ_FGVN_PNTS" AS nj_fgvn_pnts, -- NJ forgiven points.
"PASSV_RESTRA_DISC" AS passv_restra_disc, -- Passive restraint discount.
"SNR_DRVR_IND" AS snr_drvr_ind, -- Senior driver indicator.
"DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind, -- Defensive driver discount indicator.
"ANTI_THFT_DISC" AS anti_thft_disc, -- Anti-theft discount.
"DAY_TM_RUN_LIGHTS" AS day_tm_run_lights, -- Daytime running lights indicator.
"LMT_TORT" AS lmt_tort, -- Limit tort.
"ANNL_STMNT_LOB_CD" AS annl_stmnt_lob_cd, -- Annual statement line of business code.
"CVG_TYP_IND" AS cvg_typ_ind -- Coverage type indicator.
FROM {{ source('WRK_BIRP_TA_NISS_NU0C_APRM_DTL', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}