{{ config(materialized='view') }}

WITH fdr_lib_pre_fdr_fire_plcy_trans_rslt AS (
    SELECT
        "TRGT_TBL_NM" AS trgt_tbl_nm, -- Target table name
        "SRC_TBL_NM" AS src_tbl_nm, -- Source table name
        "WRKFL_CMPNT_NM" AS wrkfl_cmpnt_nm, -- Workflow component name
        "RECRD_CNT_TYP_CD" AS recrd_cnt_typ_cd, -- Record count type code
        "RECRD_CNT_ACTN_CD" AS recrd_cnt_actn_cd, -- Record count action code
        "RECRD_CNT_QTY" AS recrd_cnt_qty, -- Record count quantity
        "WRKFL_RUN_ID" AS wrkfl_run_id, -- Workflow run ID
        "WRKFL_NM" AS wrkfl_nm, -- Workflow name
        "OLD_FULL_TERM_PREM_AMT" AS old_full_term_prem_amt, -- Old full-term premium amount
        "NEW_FULL_TERM_PREM_AMT" AS new_full_term_prem_amt, -- New full-term premium amount
        "TRANS_NEW_BUS_COMM_PREM_AMT" AS trans_new_bus_comm_prem_amt, -- Transaction new business commission premium amount
        "TRANS_RNCOMM_PREM_AMT" AS trans_rncomm_prem_amt, -- Transaction renewal commission premium amount
        "TRANS_NEW_BUS_COMM_PRO_AMT" AS trans_new_bus_comm_pro_amt, -- Transaction new business commission pro amount
        "TRANS_RNCOMM_PRO_AMT" AS trans_rncomm_pro_amt, -- Transaction renewal commission pro amount
        "FSB_UNPD_BAL" AS fsb_unpd_bal, -- Unpaid balance
        "ACS_NEW_BUS_COMM_PREM_AMT" AS acs_new_bus_comm_prem_amt, -- ACS new business commission premium amount
        "PLCY_FEE_AMT" AS plcy_fee_amt, -- Policy fee amount
        "REINST_FEE_AMT" AS reinst_fee_amt, -- Reinstatement fee amount
        "ST_CHRG_AMT" AS st_chrg_amt, -- State charge amount
        "TRANS_PLCY_FEE_AMT" AS trans_plcy_fee_amt, -- Transaction policy fee amount
        "TRANS_REINST_FEE_AMT" AS trans_reinst_fee_amt, -- Transaction reinstatement fee amount
        "ACS_PLCY_FEE_AMT" AS acs_plcy_fee_amt, -- ACS policy fee amount
        "ACS_REINST_FEE_AMT" AS acs_reinst_fee_amt, -- ACS reinstatement fee amount
        "TRANS_ST_CHRG_AMT" AS trans_st_chrg_amt, -- Transaction state charge amount
        "ACS_RNCOMM_PREM_AMT" AS acs_rncomm_prem_amt, -- ACS renewal commission premium amount
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
        "ROLLUP_PLCY_FEE" AS rollup_plcy_fee, -- Rollup policy fee
        "ROLLUP_REINST_FEE" AS rollup_reinst_fee, -- Rollup reinstatement fee
        "MISC_AMT" AS misc_amt, -- Miscellaneous amount
        "REVERSAL_OLD_FULL_TERM_PREM" AS reversal_old_full_term_prem, -- Reversal old full-term premium
        "REVERSAL_NEW_FULL_TERM_PREM" AS reversal_new_full_term_prem, -- Reversal new full-term premium
        "OFF_PREM_AMT" AS off_prem_amt, -- Off premium amount
        "ON_PREM_AMT" AS on_prem_amt, -- On premium amount
        "REVERSAL_OFF_PREM_AMT" AS reversal_off_prem_amt, -- Reversal off premium amount
        "REVERSAL_ON_PREM_AMT" AS reversal_on_prem_amt -- Reversal on premium amount
    FROM {{ source('DBA_COMMON_UTILS', 'FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}
)
SELECT
    *
FROM fdr_lib_pre_fdr_fire_plcy_trans_rslt