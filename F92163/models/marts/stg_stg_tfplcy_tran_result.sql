{{ config(materialized='view') }}

WITH stg_tfplcy_tran_result AS (
    SELECT
        "TFPLCY_TRAN_RESULT_SK" AS tfplcy_tran_result_sk, -- Policy transaction result surrogate key
        "LAT_DATE" AS lat_date, -- Latest date
        "LAT_TIME" AS lat_time, -- Latest time
        "LAT_ACTION" AS lat_action, -- Latest action
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID
        "REPROC_CNT" AS reproc_cnt, -- Reprocessing count
        "POLICY_NUMBER" AS policy_number, -- Policy number
        "APPLIED_DTSTMP" AS applied_dtstmp, -- Applied timestamp
        "OLD_FT_PRM_AMT" AS old_ft_prm_amt, -- Old full-term premium amount
        "NEW_FT_PRM_AMT" AS new_ft_prm_amt, -- New full-term premium amount
        "TRN_NBCOMM_PRM_AMT" AS trn_nbcomm_prm_amt, -- Transaction new business commission premium amount
        "TRN_RNCOMM_PRM_AMT" AS trn_rncomm_prm_amt, -- Transaction renewal commission premium amount
        "TRN_NBCOMM_PRO_AMT" AS trn_nbcomm_pro_amt, -- Transaction new business commission pro amount
        "TRN_RNCOMM_PRO_AMT" AS trn_rncomm_pro_amt, -- Transaction renewal commission pro amount
        "FSB_UNPAID_BALANCE" AS fsb_unpaid_balance, -- Unpaid balance
        "ACS_NBCOMM_PRM_AMT" AS acs_nbcomm_prm_amt, -- Accumulated new business commission premium amount
        "POLICY_FEE_CD" AS policy_fee_cd, -- Policy fee code
        "POLICY_FEE_AMT" AS policy_fee_amt, -- Policy fee amount
        "REINST_FEE_AMT" AS reinst_fee_amt, -- Reinstatement fee amount
        "STATE_CHRG_AMT" AS state_chrg_amt, -- State charge amount
        "TRN_POLICY_FEE_AMT" AS trn_policy_fee_amt, -- Transaction policy fee amount
        "TRN_REINST_FEE_AMT" AS trn_reinst_fee_amt, -- Transaction reinstatement fee amount
        "ACS_POLICY_FEE_AMT" AS acs_policy_fee_amt, -- Accumulated policy fee amount
        "ACS_REINST_FEE_AMT" AS acs_reinst_fee_amt, -- Accumulated reinstatement fee amount
        "TRN_STATE_CHRG_AMT" AS trn_state_chrg_amt, -- Transaction state charge amount
        "SALES_COUNT_TOT_PD" AS sales_count_tot_pd, -- Total sales count paid
        "TRN_SALES_COUNT_PD" AS trn_sales_count_pd, -- Transaction sales count paid
        "EFF_DT" AS eff_dt, -- Effective date
        "EXP_DT" AS exp_dt, -- Expiration date
        "ACS_RNCOMM_PRM_AMT" AS acs_rncomm_prm_amt, -- Accumulated renewal commission premium amount
        "FACESHEET_PRINT_DT" AS facesheet_print_dt, -- Facesheet print date
        "TRN_OPERATING_COST" AS trn_operating_cost, -- Transaction operating cost
        "ACS_NB_COMM_AMT" AS acs_nb_comm_amt, -- Accumulated new business commission amount
        "ACS_RN_COMM_AMT" AS acs_rn_comm_amt, -- Accumulated renewal commission amount
        "ACS_NB_CITY_TX_AMT" AS acs_nb_city_tx_amt, -- Accumulated new business city tax amount
        "ACS_NB_CNTY_TX_AMT" AS acs_nb_cnty_tx_amt, -- Accumulated new business county tax amount
        "ACS_NB_SURCHG_AMT" AS acs_nb_surchg_amt, -- Accumulated new business surcharge amount
        "ACS_NB_CLCTN_FEE" AS acs_nb_clctn_fee, -- Accumulated new business collection fee
        "ACS_RN_CITY_TX_AMT" AS acs_rn_city_tx_amt, -- Accumulated renewal city tax amount
        "ACS_RN_CNTY_TX_AMT" AS acs_rn_cnty_tx_amt, -- Accumulated renewal county tax amount
        "ACS_RN_SURCHG_AMT" AS acs_rn_surchg_amt, -- Accumulated renewal surcharge amount
        "ACS_RN_CLCTN_FEE" AS acs_rn_clctn_fee, -- Accumulated renewal collection fee
        "TRN_BILLED_TAX_AMT" AS trn_billed_tax_amt, -- Transaction billed tax amount
        "TRN_SURCHARGE_AMT" AS trn_surcharge_amt, -- Transaction surcharge amount
        "TRN_COLLECTION_FEE" AS trn_collection_fee, -- Transaction collection fee
        "TRN_PRORATE_FACTOR" AS trn_prorate_factor, -- Transaction prorate factor
        "ROLLUP_POLICY_FEE" AS rollup_policy_fee, -- Rollup policy fee
        "ROLLUP_REINST_FEE" AS rollup_reinst_fee, -- Rollup reinstatement fee
        "PRE_FDR_MAPNG_ID" AS pre_fdr_mapng_id, -- Pre-fire policy mapping ID
        "MISC_AMT" AS misc_amt, -- Miscellaneous amount
        "RVRSL_OLD_FT_PRM" AS rvrsl_old_ft_prm, -- Reversal old full-term premium
        "RVRSL_NEW_FT_PRM" AS rvrsl_new_ft_prm, -- Reversal new full-term premium
        "OFF_PRM_AMT" AS off_prm_amt, -- Off-premium amount
        "ON_PRM_AMT" AS on_prm_amt, -- On-premium amount
        "RVRSL_OFF_PRM_AMT" AS rvrsl_off_prm_amt, -- Reversal off-premium amount
        "RVRSL_ON_PRM_AMT" AS rvrsl_on_prm_amt, -- Reversal on-premium amount
        "CAP_TERM_NUM" AS cap_term_num, -- Capital term number
        "RTG_CAP_CD" AS rtg_cap_cd, -- Rating capital code
        "RTG_CAP_FCTR" AS rtg_cap_fctr, -- Rating capital factor
        "HOUSEHOLD_NUM" AS household_num, -- Household number
        "ALT_PRORATE_FCTR" AS alt_prorate_fctr, -- Alternate prorate factor
        "HAZARD_DIS_PCT" AS hazard_dis_pct -- Hazard discount percentage
    FROM {{ source('DBA_COMMON_UTILS', 'STG_TFPLCY_TRAN_RESULT') }}
)
SELECT
    tfplcy_tran_result_sk,
    lat_date,
    lat_time,
    lat_action,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id,
    reproc_cnt,
    policy_number,
    applied_dtstmp,
    old_ft_prm_amt,
    new_ft_prm_amt,
    trn_nbcomm_prm_amt,
    trn_rncomm_prm_amt,
    trn_nbcomm_pro_amt,
    trn_rncomm_pro_amt,
    fsb_unpaid_balance,
    acs_nbcomm_prm_amt,
    policy_fee_cd,
    policy_fee_amt,
    reinst_fee_amt,
    state_chrg_amt,
    trn_policy_fee_amt,
    trn_reinst_fee_amt,
    acs_policy_fee_amt,
    acs_reinst_fee_amt,
    trn_state_chrg_amt,
    sales_count_tot_pd,
    trn_sales_count_pd,
    eff_dt,
    exp_dt,
    acs_rncomm_prm_amt,
    facesheet_print_dt,
    trn_operating_cost,
    acs_nb_comm_amt,
    acs_rn_comm_amt,
    acs_nb_city_tx_amt,
    acs_nb_cnty_tx_amt,
    acs_nb_surchg_amt,
    acs_nb_clctn_fee,
    acs_rn_city_tx_amt,
    acs_rn_cnty_tx_amt,
    acs_rn_surchg_amt,
    acs_rn_clctn_fee,
    trn_billed_tax_amt,
    trn_surcharge_amt,
    trn_collection_fee,
    trn_prorate_factor,
    rollup_policy_fee,
    rollup_reinst_fee,
    pre_fdr_mapng_id,
    misc_amt,
    rvrsl_old_ft_prm,
    rvrsl_new_ft_prm,
    off_prm_amt,
    on_prm_amt,
    rvrsl_off_prm_amt,
    rvrsl_on_prm_amt,
    cap_term_num,
    rtg_cap_cd,
    rtg_cap_fctr,
    household_num,
    alt_prorate_fctr,
    hazard_dis_pct
FROM stg_tfplcy_tran_result