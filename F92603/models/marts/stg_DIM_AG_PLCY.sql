{{ config(materialized='view') }}

SELECT
"PLCY_SK" AS plcy_sk, -- Surrogate key for policy.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key.
"PLCY_CNTRCT_NUM" AS plcy_cntrct_num, -- Policy contract number.
"PLCY_INCEPT_DT" AS plcy_incept_dt, -- Policy inception date.
"PERSTNCY_YRS" AS perstncy_yrs, -- Persistency years.
"LPS_DAYS_CNT" AS lps_days_cnt, -- Lapse days count.
"TERM_STRT_DT" AS term_strt_dt, -- Term start date.
"TERM_END_DT" AS term_end_dt, -- Term end date.
"PNI_AGE" AS pni_age, -- PNI age.
"XCLUDED_DRVR_CHLD_IND" AS xcluded_drvr_chld_ind, -- Excluded driver child indicator.
"XCLUDED_DRVR_OTH_IND" AS xcluded_drvr_oth_ind, -- Excluded driver other indicator.
"XCLUDED_DRVR_PARENT_IND" AS xcluded_drvr_parent_ind, -- Excluded driver parent indicator.
"XCLUDED_DRVR_SPS_IND" AS xcluded_drvr_sps_ind, -- Excluded driver spouse indicator.
"LIFE_PLCY_IND" AS life_plcy_ind, -- Life policy indicator.
"ADVNC_PURCH_IND" AS advnc_purch_ind, -- Advance purchase indicator.
"ALTR_VEH_IND" AS altr_veh_ind, -- Alternative vehicle indicator.
"ALTRN_FUEL_IND" AS altrn_fuel_ind, -- Alternative fuel indicator.
"ABS_IND" AS abs_ind, -- ABS indicator.
"ANTI_THFT_IND" AS anti_thft_ind, -- Anti-theft indicator.
"ANTIQ_CAR_IND" AS antiq_car_ind, -- Antique car indicator.
"DRVR_TRNG_IND" AS drvr_trng_ind, -- Driver training indicator.
"ELECTRNC_STABLTY_CTRL_DISC_IND" AS electrnc_stablty_ctrl_disc_ind, -- Electronic stability control discount indicator.
"HI_PERF_IND" AS hi_perf_ind, -- High performance indicator.
"NEW_PARENT_IND" AS new_parent_ind, -- New parent indicator.
"PASSV_RESTRA_IND" AS passv_restra_ind, -- Passive restraint indicator.
"PRI_INS_DISC_IND" AS pri_ins_disc_ind, -- Primary insurance discount indicator.
"CONVICT_FREE_IND" AS convict_free_ind, -- Conviction-free indicator.
"SR22_FILNG_IND" AS sr22_filng_ind, -- SR22 filing indicator.
"DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind, -- Defensive driver discount indicator.
"TEEN_DRVR_IND" AS teen_drvr_ind, -- Teen driver indicator.
"SNR_DRVR_IND" AS snr_drvr_ind, -- Senior driver indicator.
"UNVERFYBL_DRVNG_RECRD_IND" AS unverfybl_drvng_recrd_ind, -- Unverifiable driving record indicator.
"MINI_PLCY_SK" AS mini_plcy_sk, -- Mini policy surrogate key.
"MINI_PLCY_CHK_SUM" AS mini_plcy_chk_sum, -- Mini policy checksum.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID.
FROM {{ source('staging', 'DIM_AG_PLCY') }}