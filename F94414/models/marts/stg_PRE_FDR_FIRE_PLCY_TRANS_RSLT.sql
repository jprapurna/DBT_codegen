{{ config(materialized='view') }}

WITH pre_fdr_fire_plcy_trans_rslt AS (
    SELECT
        "PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
        "TRANS_TMSP" AS trans_tmsp, -- Transaction timestamp
        "EFF_DT" AS eff_dt, -- Effective date
        "END_EFF_DT" AS end_eff_dt, -- End effective date
        "OLD_FULL_TERM_PREM_AMT" AS old_full_term_prem_amt, -- Old full-term premium amount
        "NEW_FULL_TERM_PREM_AMT" AS new_full_term_prem_amt, -- New full-term premium amount
        "TRANS_NEW_BUS_COMM_PREM_AMT" AS trans_new_bus_comm_prem_amt, -- Transaction new business commission premium amount
        "TRANS_RNCOMM_PREM_AMT" AS trans_rncomm_prem_amt, -- Transaction renewal commission premium amount
        "TRANS_NEW_BUS_COMM_PRO_AMT" AS trans_new_bus_comm_pro_amt, -- Transaction new business commission pro amount
        "TRANS_RNCOMM_PRO_AMT" AS trans_rncomm_pro_amt, -- Transaction renewal commission pro amount
        "FSB_UNPD_BAL" AS fsb_unpd_bal, -- Unpaid balance
        "ACS_NEW_BUS_COMM_PREM_AMT" AS acs_new_bus_comm_prem_amt, -- ACS new business commission premium amount
        "PLCY_FEE_CD" AS plcy_fee_cd, -- Policy fee code
        "PLCY_FEE_AMT" AS plcy_fee_amt, -- Policy fee amount
        "REINST_FEE_AMT" AS reinst_fee_amt, -- Reinstatement fee amount
        "ST_CHRG_AMT" AS st_chrg_amt, -- State charge amount
        "TRANS_PLCY_FEE_AMT" AS trans_plcy_fee_amt, -- Transaction policy fee amount
        "TRANS_REINST_FEE_AMT" AS trans_reinst_fee_amt, -- Transaction reinstatement fee amount
        "ACS_PLCY_FEE_AMT" AS acs_plcy_fee_amt, -- ACS policy fee amount
        "ACS_REINST_FEE_AMT" AS acs_reinst_fee_amt, -- ACS reinstatement fee amount
        "TRANS_ST_CHRG_AMT" AS trans_st_chrg_amt, -- Transaction state charge amount
        "SLS_CNT_TTL_PD" AS sls_cnt_ttl_pd, -- Sales count total paid
        "TRANS_SLS_CNT_PD" AS trans_sls_cnt_pd, -- Transaction sales count paid
        "EXP_DT" AS exp_dt, -- Expiration date
        "ACS_RNCOMM_PREM_AMT" AS acs_rncomm_prem_amt, -- ACS renewal commission premium amount
        "FACESHEET_PRNT_DT" AS facesheet_prnt_dt, -- Facesheet print date
        "TRANS_OPERTNG_COST" AS trans_opertng_cost, -- Transaction operating cost
        "ACS_NEW_BUS_COMM_AMT" AS acs_new_bus_comm_amt, -- ACS new business commission amount
        "ACS_RNCOMM_AMT" AS acs_rncomm_amt, -- ACS renewal commission amount
        "ACS_NEW_BUS_CITY_TAX_AMT" AS acs_new_bus_city_tax_amt, -- ACS new business city tax amount
        "ACS_NEW_BUS_CNTY_TAX_AMT" AS acs_new_bus_cnty_tax_amt, -- ACS new business county tax amount
        "ACS_NEW_BUS_SURCHRG_AMT" AS acs_new_bus_surchrg_amt, -- ACS new business surcharge amount
        "ACS_NEW_BUS_CLCT_FEE" AS acs_new_bus_clct_fee, -- ACS new business collection fee
        "ACS_RNWL_CITY_TAX_AMT" AS acs_rnwl_city_tax_amt, -- ACS renewal city tax amount
        "ACS_RNWL_CNTY_TAX_AMT" AS acs_rnwl_cnty_tax_amt, -- ACS renewal county tax amount
        "ACS_RNWL_SURCHRG_AMT" AS acs_rnwl_surchrg_amt, -- ACS renewal surcharge amount
        "ACS_RNWL_CLCT_FEE" AS acs_rnwl_clct_fee, -- ACS renewal collection fee
        "TRANS_BILL_TAX_AMT" AS trans_bill_tax_amt, -- Transaction billed tax amount
        "TRANS_SURCHRG_AMT" AS trans_surchrg_amt, -- Transaction surcharge amount
        "TRANS_CLCT_FEE" AS trans_clct_fee, -- Transaction collection fee
        "TRANS_PRORT_FCTR" AS trans_prort_fctr, -- Transaction prorate factor
        "ROLLUP_PLCY_FEE" AS rollup_plcy_fee, -- Rollup policy fee
        "ROLLUP_REINST_FEE" AS rollup_reinst_fee, -- Rollup reinstatement fee
        "MISC_AMT" AS misc_amt, -- Miscellaneous amount
        "CAP_TERM_NUM" AS cap_term_num, -- Capital term number
        "RTG_CAP_CD" AS rtg_cap_cd, -- Rating capital code
        "RTG_CAP_FCTR" AS rtg_cap_fctr, -- Rating capital factor
        "REVERSAL_OLD_FULL_TERM_PREM" AS reversal_old_full_term_prem, -- Reversal old full-term premium
        "REVERSAL_NEW_FULL_TERM_PREM" AS reversal_new_full_term_prem, -- Reversal new full-term premium
        "OFF_PREM_AMT" AS off_prem_amt, -- Off premium amount
        "ON_PREM_AMT" AS on_prem_amt, -- On premium amount
        "REVERSAL_OFF_PREM_AMT" AS reversal_off_prem_amt, -- Reversal off premium amount
        "REVERSAL_ON_PREM_AMT" AS reversal_on_prem_amt, -- Reversal on premium amount
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID
        "SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
        "SRC_HH_NUM" AS src_hh_num, -- Source household number
        "PROC_CD" AS proc_cd, -- Process code
        "MAJOR_SOI_ID" AS major_soi_id, -- Major SOI ID
        "ALTRN_PRORT_FCTR" AS altrn_prort_fctr, -- Alternate prorate factor
        "HAZARD_DIS_PCT" AS hazard_dis_pct, -- Hazard discount percentage
        "FL_CPIC_EMERG_SURCHRG_AMT" AS fl_cpic_emerg_surchrg_amt, -- Florida CPIC emergency surcharge amount
        "FL_CPIC_REG_ASSMNT_AMT" AS fl_cpic_reg_assmnt_amt, -- Florida CPIC regular assessment amount
        "FL_EMERG_PREP_ASSMNT_AMT" AS fl_emerg_prep_assmnt_amt, -- Florida emergency preparedness assessment amount
        "FL_HURR_CAT_FUND_AMT" AS fl_hurr_cat_fund_amt, -- Florida hurricane catastrophe fund amount
        "FL_IGA_EMERG_AMT" AS fl_iga_emerg_amt, -- Florida IGA emergency amount
        "FL_IGA_REG_AMT" AS fl_iga_reg_amt, -- Florida IGA regular amount
        "MERG_TYP_CD" AS merg_typ_cd, -- Merge type code
        "NON_RNWL_IND" AS non_rnwl_ind, -- Non-renewal indicator
        "NR_RVRSL_IND" AS nr_rvrsl_ind, -- Non-renewal reversal indicator
        "SRC_SYS_CD" AS src_sys_cd, -- Source system code
        "SRC_TRN_ID" AS src_trn_id, -- Source transaction ID
        "TRANS_CITY_TAX_AMT" AS trans_city_tax_amt, -- Transaction city tax amount
        "TRANS_CNTY_TAX_AMT" AS trans_cnty_tax_amt, -- Transaction county tax amount
        "TRANS_CITY_TAX_FEE_AMT" AS trans_city_tax_fee_amt, -- Transaction city tax fee amount
        "TRANS_CNTY_TAX_FEE_AMT" AS trans_cnty_tax_fee_amt, -- Transaction county tax fee amount
        "TRANS_SURCHRG_FEE_AMT" AS trans_surchrg_fee_amt, -- Transaction surcharge fee amount
        "LA_CST_PLAN_REG_ASSMNT" AS la_cst_plan_reg_assmnt, -- Louisiana cost plan regular assessment
        "LA_CST_PLAN_EMERG_ASSMNT" AS la_cst_plan_emerg_assmnt, -- Louisiana cost plan emergency assessment
        "LA_FAIR_PLAN_REG_ASSMNT" AS la_fair_plan_reg_assmnt, -- Louisiana fair plan regular assessment
        "LA_FAIR_PLAN_EMERG_ASSMNT" AS la_fair_plan_emerg_assmnt, -- Louisiana fair plan emergency assessment
        "NCRB_PREM_AMT" AS ncrb_prem_amt, -- NCRB premium amount
        "FRMS_NC_PREM_AMT" AS frms_nc_prem_amt, -- Forms NC premium amount
        "CAT_RCVRY_CHRG_AMT" AS cat_rcvry_chrg_amt, -- Catastrophe recovery charge amount
        "FRMS_UNCPD_PREM_AMT" AS frms_uncpd_prem_amt, -- Forms unpaid premium amount
        "BNDG_USR_ROLE_DESC" AS bndg_usr_role_desc, -- Binding user role description
        "EVNT_INTIATD_BY_SHRT_DESC" AS evnt_intiatd_by_shrt_desc, -- Event initiated by short description
        "ROLLUP_PLCY_FEE_AMT" AS rollup_plcy_fee_amt, -- Rollup policy fee amount
        "ROLLUP_RNSTTMNT_FEE_AMT" AS rollup_rnsttmnt_fee_amt, -- Rollup reinstatement fee amount
        "RATE_CHNG_IND" AS rate_chng_ind, -- Rate change indicator
        "FIGA_PRPTY_CRDT_AMT" AS figa_prpty_crdt_amt, -- FIGA property credit amount
        "ACCM_TRN_NTRL_DISMIT_FEE" AS accm_trn_ntrl_dismit_fee, -- Accumulated transaction neutral dismissal fee
        "TRN_NTRL_DISMIT_FEE" AS trn_ntrl_dismit_fee -- Transaction neutral dismissal fee
    FROM {{ source('DBA_COMMON_UTILS', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}
)
SELECT
    *
FROM pre_fdr_fire_plcy_trans_rslt