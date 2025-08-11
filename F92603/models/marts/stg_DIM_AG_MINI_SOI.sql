{{ config(materialized='view') }}

SELECT
"MINI_SOI_SK" AS mini_soi_sk, -- Surrogate key for mini SOI.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"VEH_TYP_CD" AS veh_typ_cd, -- Vehicle type code.
"VEH_TYP_DESC" AS veh_typ_desc, -- Vehicle type description.
"SOI_CTGY" AS soi_ctgy, -- SOI category.
"VEH_USE_CD" AS veh_use_cd, -- Vehicle use code.
"MCA_PNT_CNT_RNGE" AS mca_pnt_cnt_rnge, -- MCA point count range.
"ANN_MIL_RNGE" AS ann_mil_rnge, -- Annual mileage range.
"CAR_SYM_RNGE" AS car_sym_rnge, -- Car symbol range.
"RDRVR_AGE_RNGE" AS rdrvr_age_rnge, -- Driver age range.
"RATE_CLS_CD" AS rate_cls_cd, -- Rate class code.
"OCCUPTN_CD" AS occuptn_cd, -- Occupation code.
"OCCUPTN_DESC" AS occuptn_desc, -- Occupation description.
"OCCUPTN_CD_PRGM" AS occuptn_cd_prgm, -- Occupation code program.
"COLL_DED" AS coll_ded, -- Collision deductible.
"CA_PNTD_IND" AS ca_pntd_ind, -- CA pointed indicator.
"GRP_DISC_IND" AS grp_disc_ind, -- Group discount indicator.
"NEW_CAR_CRED_IND" AS new_car_cred_ind, -- New car credit indicator.
"RETRMNT_CMNTY_DISC_IND" AS retrmnt_cmnty_disc_ind, -- Retirement community discount indicator.
"VEH_USE_SURCHRG_IND" AS veh_use_surchrg_ind, -- Vehicle use surcharge indicator.
"LXRY_VEH_IND" AS lxry_veh_ind, -- Luxury vehicle indicator.
"FULL_CVG_IND" AS full_cvg_ind, -- Full coverage indicator.
"YTHFL_RDRVR_IND" AS ythfl_rdrvr_ind, -- Youthful driver indicator.
"GOOD_DRVR_IND" AS good_drvr_ind, -- Good driver indicator.
"GOOD_STDNT_IND" AS good_stdnt_ind, -- Good student indicator.
"YES_IND" AS yes_ind, -- Yes indicator.
"MAT_DRVR_DISC_IND" AS mat_drvr_disc_ind, -- Mature driver discount indicator.
"SAFE_DRVNG_DISC_IND" AS safe_drvng_disc_ind, -- Safe driving discount indicator.
"COMPRE_WTHT_COLL_SURCHRG_IND" AS compre_wtht_coll_surchrg_ind, -- Comprehensive without collision surcharge indicator.
"ERLY_SHOPPNG_DISC_IND" AS erly_shoppng_disc_ind, -- Early shopping discount indicator.
"EFT_IND" AS eft_ind, -- EFT indicator.
"PD_IN_FULL_IND" AS pd_in_full_ind, -- Paid in full indicator.
"NON_FIG_HO_CRED_IND" AS non_fig_ho_cred_ind, -- Non-fig HO credit indicator.
"TRNSFR_DISC_IND" AS trnsfr_disc_ind, -- Transfer discount indicator.
"MLT_CAR_IND" AS mlt_car_ind, -- Multi-car indicator.
"MLT_LINE_IND" AS mlt_line_ind, -- Multi-line indicator.
"NEW_HH_IND" AS new_hh_ind, -- New household indicator.
"SUM_SOI_CHK_SUM" AS sum_soi_chk_sum, -- Sum SOI checksum.
"SUM_SOI_SK" AS sum_soi_sk, -- Sum SOI surrogate key.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID.
"CA_SNR_DRVR_DISC_IND" AS ca_snr_drvr_disc_ind, -- CA senior driver discount indicator.
"CA_STDNT_AWAY_IND" AS ca_stdnt_away_ind -- CA student away indicator.
FROM {{ source('staging', 'DIM_AG_MINI_SOI') }}