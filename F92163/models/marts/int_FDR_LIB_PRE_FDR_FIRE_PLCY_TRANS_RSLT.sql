{{ config(materialized='table') }}

SELECT 
    {{ var('TARGET_TABLE_NAME') }},  
    'STG_TFPLCY_TRAN_RESULT', 
    {{ var('WORKFLOW_COMPONENT_NAME') }}, 
    'T', 
    'I', 
    COUNT(*), 
    wrk_flow_run_id, 
    {{ var('WORKFLOW_NAME') }},
    SUM(old_full_term_prem_amt) AS old_full_term_prem_amt,
    SUM(new_full_term_prem_amt) AS new_full_term_prem_amt,
    SUM(trans_new_bus_comm_prem_amt) AS trans_new_bus_comm_prem_amt,
    SUM(trans_rncomm_prem_amt) AS trans_rncomm_prem_amt,
    SUM(trans_new_bus_comm_pro_amt) AS trans_new_bus_comm_pro_amt,
    SUM(trans_rncomm_pro_amt) AS trans_rncomm_pro_amt,
    SUM(fsb_unpd_bal) AS fsb_unpd_bal,
    SUM(acs_new_bus_comm_prem_amt) AS acs_new_bus_comm_prem_amt,
    SUM(plcy_fee_amt) AS plcy_fee_amt,
    SUM(reinst_fee_amt) AS reinst_fee_amt,
    SUM(st_chrg_amt) AS st_chrg_amt,
    SUM(trans_plcy_fee_amt) AS trans_plcy_fee_amt,
    SUM(trans_reinst_fee_amt) AS trans_reinst_fee_amt,
    SUM(acs_plcy_fee_amt) AS acs_plcy_fee_amt,
    SUM(acs_reinst_fee_amt) AS acs_reinst_fee_amt,
    SUM(trans_st_chrg_amt) AS trans_st_chrg_amt,
    SUM(acs_rncomm_prem_amt) AS acs_rncomm_prem_amt,
    SUM(trans_opertng_cost) AS trans_opertng_cost,
    SUM(acs_new_bus_comm_amt) AS acs_new_bus_comm_amt,
    SUM(acs_rncomm_amt) AS acs_rncomm_amt,
    SUM(acs_new_bus_city_tax_amt) AS acs_new_bus_city_tax_amt,
    SUM(acs_new_bus_cnty_tax_amt) AS acs_new_bus_cnty_tax_amt,
    SUM(acs_new_bus_surchrg_amt) AS acs_new_bus_surchrg_amt,
    SUM(acs_new_bus_clct_fee) AS acs_new_bus_clct_fee,
    SUM(acs_rnwl_city_tax_amt) AS acs_rnwl_city_tax_amt,
    SUM(acs_rnwl_cnty_tax_amt) AS acs_rnwl_cnty_tax_amt,
    SUM(acs_rnwl_surchrg_amt) AS acs_rnwl_surchrg_amt,
    SUM(acs_rnwl_clct_fee) AS acs_rnwl_clct_fee,
    SUM(trans_bill_tax_amt) AS trans_bill_tax_amt,
    SUM(trans_surchrg_amt) AS trans_surchrg_amt,
    SUM(trans_clct_fee) AS trans_clct_fee,
    SUM(rollup_plcy_fee) AS rollup_plcy_fee,
    SUM(rollup_reinst_fee) AS rollup_reinst_fee,
    SUM(misc_amt) AS misc_amt,
    SUM(REVERSAL_OLD_FULL_TERM_PREM) AS REVERSAL_OLD_FULL_TERM_PREM,
    SUM(REVERSAL_NEW_FULL_TERM_PREM) AS REVERSAL_NEW_FULL_TERM_PREM,
    SUM(OFF_PREM_AMT) AS OFF_PREM_AMT,
    SUM(ON_PREM_AMT) AS ON_PREM_AMT,
    SUM(REVERSAL_OFF_PREM_AMT) AS REVERSAL_OFF_PREM_AMT,
    SUM(REVERSAL_ON_PREM_AMT) AS REVERSAL_ON_PREM_AMT
FROM 
    {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
WHERE 
    dw_cr_tmsp = (
        SELECT MAX(dw_upd_tmsp) 
        FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    ) 
    AND dw_cr_tmsp = dw_upd_tmsp 
    AND wrk_flow_run_id = (
        SELECT MAX(wrkfl_run_id) 
        FROM {{ source('ABC', 'abc_audit_wrkfl_run') }} r, 
             {{ source('ABC', 'abc_ctrl_wrkfl_prmtr') }} p 
        WHERE 
            p.wrkfl_nm = {{ var('WORKFLOW_NAME') }} 
            AND r.wrkfl_id = p.wrkfl_id
    )
GROUP BY 
    wrk_flow_run_id
UNION
SELECT 
    {{ var('TARGET_TABLE_NAME') }},  
    'STG_TFPLCY_TRAN_RESULT', 
    {{ var('WORKFLOW_COMPONENT_NAME') }}, 
    'T', 
    'U', 
    COUNT(*), 
    wrk_flow_run_id, 
    {{ var('WORKFLOW_NAME') }},
    SUM(old_full_term_prem_amt) AS old_full_term_prem_amt,
    SUM(new_full_term_prem_amt) AS new_full_term_prem_amt,
    SUM(trans_new_bus_comm_prem_amt) AS trans_new_bus_comm_prem_amt,
    SUM(trans_rncomm_prem_amt) AS trans_rncomm_prem_amt,
    SUM(trans_new_bus_comm_pro_amt) AS trans_new_bus_comm_pro_amt,
    SUM(trans_rncomm_pro_amt) AS trans_rncomm_pro_amt,
    SUM(fsb_unpd_bal) AS fsb_unpd_bal,
    SUM(acs_new_bus_comm_prem_amt) AS acs_new_bus_comm_prem_amt,
    SUM(plcy_fee_amt) AS plcy_fee_amt,
    SUM(reinst_fee_amt) AS reinst_fee_amt,
    SUM(st_chrg_amt) AS st_chrg_amt,
    SUM(trans_plcy_fee_amt) AS trans_plcy_fee_amt,
    SUM(trans_reinst_fee_amt) AS trans_reinst_fee_amt,
    SUM(acs_plcy_fee_amt) AS acs_plcy_fee_amt,
    SUM(acs_reinst_fee_amt) AS acs_reinst_fee_amt,
    SUM(trans_st_chrg_amt) AS trans_st_chrg_amt,
    SUM(acs_rncomm_prem_amt) AS acs_rncomm_prem_amt,
    SUM(trans_opertng_cost) AS trans_opertng_cost,
    SUM(acs_new_bus_comm_amt) AS acs_new_bus_comm_amt,
    SUM(acs_rncomm_amt) AS acs_rncomm_amt,
    SUM(acs_new_bus_city_tax_amt) AS acs_new_bus_city_tax_amt,
    SUM(acs_new_bus_cnty_tax_amt) AS acs_new_bus_cnty_tax_amt,
    SUM(acs_new_bus_surchrg_amt) AS acs_new_bus_surchrg_amt,
    SUM(acs_new_bus_clct_fee) AS acs_new_bus_clct_fee,
    SUM(acs_rnwl_city_tax_amt) AS acs_rnwl_city_tax_amt,
    SUM(acs_rnwl_cnty_tax_amt) AS acs_rnwl_cnty_tax_amt,
    SUM(acs_rnwl_surchrg_amt) AS acs_rnwl_surchrg_amt,
    SUM(acs_rnwl_clct_fee) AS acs_rnwl_clct_fee,
    SUM(trans_bill_tax_amt) AS trans_bill_tax_amt,
    SUM(trans_surchrg_amt) AS trans_surchrg_amt,
    SUM(trans_clct_fee) AS trans_clct_fee,
    SUM(rollup_plcy_fee) AS rollup_plcy_fee,
    SUM(rollup_reinst_fee) AS rollup_reinst_fee,
    SUM(misc_amt) AS misc_amt,
    SUM(REVERSAL_OLD_FULL_TERM_PREM) AS REVERSAL_OLD_FULL_TERM_PREM,
    SUM(REVERSAL_NEW_FULL_TERM_PREM) AS REVERSAL_NEW_FULL_TERM_PREM,
    SUM(OFF_PREM_AMT) AS OFF_PREM_AMT,
    SUM(ON_PREM_AMT) AS ON_PREM_AMT,
    SUM(REVERSAL_OFF_PREM_AMT) AS REVERSAL_OFF_PREM_AMT,
    SUM(REVERSAL_ON_PREM_AMT) AS REVERSAL_ON_PREM_AMT
FROM 
    {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
WHERE 
    dw_upd_tmsp = (
        SELECT MAX(dw_upd_tmsp) 
        FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    ) 
    AND dw_upd_tmsp > dw_cr_tmsp 
    AND wrk_flow_run_id = (
        SELECT MAX(wrkfl_run_id) 
        FROM {{ source('ABC', 'abc_audit_wrkfl_run') }} r, 
             {{ source('ABC', 'abc_ctrl_wrkfl_prmtr') }} p 
        WHERE 
            p.wrkfl_nm = {{ var('WORKFLOW_NAME') }} 
            AND r.wrkfl_id = p.wrkfl_id
    )
GROUP BY 
    wrk_flow_run_id;