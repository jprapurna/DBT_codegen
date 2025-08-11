{{ config(materialized='view') }}

SELECT
"MINI_PLCY_SK" AS mini_plcy_sk, -- Mini policy SK.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"MKT_TIER_FA2" AS mkt_tier_fa2, -- Market tier FA2.
"PAY_PLAN_CD" AS pay_plan_cd, -- Pay plan code.
"PAY_PLAN_DESC" AS pay_plan_desc, -- Pay plan description.
"PERSTNCY_YRS_RNGE" AS perstncy_yrs_rnge, -- Persistency years range.
"PNI_AGE_RNGE" AS pni_age_rnge, -- PNI age range.
"TERM_LNGTH_MNTHS" AS term_lngth_mnths, -- Term length in months.
"CMPY_CD" AS cmpy_cd, -- Company code.
"CMPY_DESC" AS cmpy_desc, -- Company description.
"RATNG_CMPY_CD" AS ratng_cmpy_cd, -- Rating company code.
"RATNG_CMPY_DESC" AS ratng_cmpy_desc, -- Rating company description.
"FIRST_PRTY_CRED_TIER_MDL_C" AS first_prty_cred_tier_mdl_c, -- First party credit tier model C.
"LIAB_CRED_TIER_MDL_A" AS liab_cred_tier_mdl_a, -- Liability credit tier model A.
"PD_CRED_TIER_MDL_D" AS pd_cred_tier_mdl_d, -- PD credit tier model D.
"UW_TIER_CD" AS uw_tier_cd, -- Underwriting tier code.
"DAYS_LPS_CD" AS days_lps_cd, -- Days lapse code.
"PRI_INS_NAIC_CMPNY_CD" AS pri_ins_naic_cmpny_cd, -- Primary insurance NAIC company code.
"PRI_CARR_TYP" AS pri_carr_typ, -- Primary carrier type.
"PRI_BI_LMT_AMT" AS pri_bi_lmt_amt, -- Primary bodily injury limit amount.
"PRI_BI_LMT_CD" AS pri_bi_lmt_cd, -- Primary bodily injury limit code.
"BI_LMT" AS bi_lmt, -- Bodily injury limit.
"COMPRE_WTHT_COLL_SURCHRG_IND" AS compre_wtht_coll_surchrg_ind, -- Comprehensive without collision surcharge indicator.
"ERLY_SHOPPNG_DISC_IND" AS erly_shoppng_disc_ind, -- Early shopping discount indicator.
"EFT_IND" AS eft_ind, -- EFT indicator.
"PD_IN_FULL_IND" AS pd_in_full_ind, -- Paid in full indicator.
"MLT_CAR_IND" AS mlt_car_ind, -- Multi-car indicator.
"MLT_LINE_IND" AS mlt_line_ind, -- Multi-line indicator.
"NEW_HH_IND" AS new_hh_ind, -- New household indicator.
"NON_FIG_HO_CRED_IND" AS non_fig_ho_cred_ind, -- Non-fig HO credit indicator.
"TRNSFR_DISC_IND" AS trnsfr_disc_ind, -- Transfer discount indicator.
"FA2_PLCY_IND" AS fa2_plcy_ind, -- FA2 policy indicator.
"YTHFL_PNI_IND" AS ythfl_pni_ind, -- Youthful PNI indicator.
"DPS_IND" AS dps_ind, -- DPS indicator.
"GRP_DISC_IND" AS grp_disc_ind, -- Group discount indicator.
"NEW_CAR_CRED_IND" AS new_car_cred_ind, -- New car credit indicator.
"RETRMNT_CMNTY_DISC_IND" AS retrmnt_cmnty_disc_ind, -- Retirement community discount indicator.
"VEH_USE_SURCHRG_IND" AS veh_use_surchrg_ind, -- Vehicle use surcharge indicator.
"GOOD_DRVR_IND" AS good_drvr_ind, -- Good driver indicator.
"GOOD_STDNT_IND" AS good_stdnt_ind, -- Good student indicator.
"YES_IND" AS yes_ind, -- Yes indicator.
"MAT_DRVR_DISC_IND" AS mat_drvr_disc_ind, -- Mature driver discount indicator.
"SAFE_DRVNG_DISC_IND" AS safe_drvng_disc_ind, -- Safe driving discount indicator.
"SUM_PLCY_CHK_SUM" AS sum_plcy_chk_sum, -- Sum policy checksum.
"SUM_PLCY_SK" AS sum_plcy_sk, -- Sum policy SK.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID.
"CA_SNR_DRVR_DISC_IND" AS ca_snr_drvr_disc_ind, -- CA senior driver discount indicator.
"CA_STDNT_AWAY_IND" AS ca_stdnt_away_ind -- CA student away indicator.
FROM {{ source('DIM_AG_MINI_PLCY', 'DIM_AG_MINI_PLCY') }}