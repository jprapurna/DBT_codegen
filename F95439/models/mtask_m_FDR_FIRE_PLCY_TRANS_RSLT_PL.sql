-- Source node: FDR_LIB_STG_TFPLCY_TRAN_RESULT
WITH FDR_LIB_STG_TFPLCY_TRAN_RESULT AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK AS TFPLCY_TRAN_RESULT_SK, -- INTEGER
        LAT_DATE AS LAT_DATE, -- DATE
        LAT_TIME AS LAT_TIME, -- TIME
        LAT_ACTION AS LAT_ACTION, -- VARCHAR
        CR_BY_MAPNG_ID AS CR_BY_MAPNG_ID, -- INTEGER
        DW_CR_TMSP AS DW_CR_TMSP, -- TIMESTAMPNTZ
        UPD_BY_MAPNG_ID AS UPD_BY_MAPNG_ID, -- INTEGER
        DW_UPD_TMSP AS DW_UPD_TMSP, -- TIMESTAMPNTZ
        WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID, -- INTEGER
        REPROC_CNT AS REPROC_CNT, -- INTEGER
        POLICY_NUMBER AS POLICY_NUMBER, -- INTEGER
        APPLIED_DTSTMP AS APPLIED_DTSTMP, -- TIMESTAMPNTZ
        OLD_FT_PRM_AMT AS OLD_FT_PRM_AMT, -- NUMBER
        NEW_FT_PRM_AMT AS NEW_FT_PRM_AMT, -- NUMBER
        TRN_NBCOMM_PRM_AMT AS TRN_NBCOMM_PRM_AMT, -- NUMBER
        TRN_RNCOMM_PRM_AMT AS TRN_RNCOMM_PRM_AMT, -- NUMBER
        TRN_NBCOMM_PRO_AMT AS TRN_NBCOMM_PRO_AMT, -- NUMBER
        TRN_RNCOMM_PRO_AMT AS TRN_RNCOMM_PRO_AMT, -- NUMBER
        FSB_UNPAID_BALANCE AS FSB_UNPAID_BALANCE, -- NUMBER
        ACS_NBCOMM_PRM_AMT AS ACS_NBCOMM_PRM_AMT, -- NUMBER
        POLICY_FEE_CD AS POLICY_FEE_CD, -- VARCHAR
        POLICY_FEE_AMT AS POLICY_FEE_AMT, -- NUMBER
        REINST_FEE_AMT AS REINST_FEE_AMT, -- NUMBER
        STATE_CHRG_AMT AS STATE_CHRG_AMT, -- NUMBER
        TRN_POLICY_FEE_AMT AS TRN_POLICY_FEE_AMT, -- NUMBER
        TRN_REINST_FEE_AMT AS TRN_REINST_FEE_AMT, -- NUMBER
        ACS_POLICY_FEE_AMT AS ACS_POLICY_FEE_AMT, -- NUMBER
        ACS_REINST_FEE_AMT AS ACS_REINST_FEE_AMT, -- NUMBER
        TRN_STATE_CHRG_AMT AS TRN_STATE_CHRG_AMT, -- NUMBER
        SALES_COUNT_TOT_PD AS SALES_COUNT_TOT_PD, -- INTEGER
        TRN_SALES_COUNT_PD AS TRN_SALES_COUNT_PD, -- INTEGER
        EFF_DT AS EFF_DT, -- DATE
        EXP_DT AS EXP_DT, -- DATE
        ACS_RNCOMM_PRM_AMT AS ACS_RNCOMM_PRM_AMT, -- NUMBER
        FACESHEET_PRINT_DT AS FACESHEET_PRINT_DT, -- DATE
        TRN_OPERATING_COST AS TRN_OPERATING_COST, -- NUMBER
        ACS_NB_COMM_AMT AS ACS_NB_COMM_AMT, -- NUMBER
        ACS_RN_COMM_AMT AS ACS_RN_COMM_AMT, -- NUMBER
        ACS_NB_CITY_TX_AMT AS ACS_NB_CITY_TX_AMT, -- NUMBER
        ACS_NB_CNTY_TX_AMT AS ACS_NB_CNTY_TX_AMT, -- NUMBER
        ACS_NB_SURCHG_AMT AS ACS_NB_SURCHG_AMT, -- NUMBER
        ACS_NB_CLCTN_FEE AS ACS_NB_CLCTN_FEE, -- NUMBER
        ACS_RN_CITY_TX_AMT AS ACS_RN_CITY_TX_AMT, -- NUMBER
        ACS_RN_CNTY_TX_AMT AS ACS_RN_CNTY_TX_AMT, -- NUMBER
        ACS_RN_SURCHG_AMT AS ACS_RN_SURCHG_AMT, -- NUMBER
        ACS_RN_CLCTN_FEE AS ACS_RN_CLCTN_FEE, -- NUMBER
        TRN_BILLED_TAX_AMT AS TRN_BILLED_TAX_AMT, -- NUMBER
        TRN_SURCHARGE_AMT AS TRN_SURCHARGE_AMT, -- NUMBER
        TRN_COLLECTION_FEE AS TRN_COLLECTION_FEE, -- NUMBER
        TRN_PRORATE_FACTOR AS TRN_PRORATE_FACTOR, -- NUMBER
        ROLLUP_POLICY_FEE AS ROLLUP_POLICY_FEE, -- NUMBER
        ROLLUP_REINST_FEE AS ROLLUP_REINST_FEE, -- NUMBER
        PRE_FDR_MAPNG_ID AS PRE_FDR_MAPNG_ID, -- INTEGER
        MISC_AMT AS MISC_AMT, -- NUMBER
        RVRSL_OLD_FT_PRM AS RVRSL_OLD_FT_PRM, -- NUMBER
        RVRSL_NEW_FT_PRM AS RVRSL_NEW_FT_PRM, -- NUMBER
        OFF_PRM_AMT AS OFF_PRM_AMT, -- NUMBER
        ON_PRM_AMT AS ON_PRM_AMT, -- NUMBER
        RVRSL_OFF_PRM_AMT AS RVRSL_OFF_PRM_AMT, -- NUMBER
        RVRSL_ON_PRM_AMT AS RVRSL_ON_PRM_AMT, -- NUMBER
        CAP_TERM_NUM AS CAP_TERM_NUM, -- INTEGER
        RTG_CAP_CD AS RTG_CAP_CD, -- VARCHAR
        RTG_CAP_FCTR AS RTG_CAP_FCTR, -- NUMBER
        HOUSEHOLD_NUM AS HOUSEHOLD_NUM, -- VARCHAR
        ALT_PRORATE_FCTR AS ALT_PRORATE_FCTR, -- NUMBER
        HAZARD_DIS_PCT AS HAZARD_DIS_PCT -- NUMBER
    FROM {{ source('fire_policy', 'STG_TFPLCY_TRAN_RESULT') }}
)


-- Source node: FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT
, FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT AS (
    SELECT 
        PLCY_ID_SK, -- NUMBER
        TRANS_TMSP, -- TIMESTAMPNTZ
        EFF_DT, -- DATE
        END_EFF_DT, -- DATE
        OLD_FULL_TERM_PREM_AMT, -- NUMBER
        NEW_FULL_TERM_PREM_AMT, -- NUMBER
        TRANS_NEW_BUS_COMM_PREM_AMT, -- NUMBER
        TRANS_RNCOMM_PREM_AMT, -- NUMBER
        TRANS_NEW_BUS_COMM_PRO_AMT, -- NUMBER
        TRANS_RNCOMM_PRO_AMT, -- NUMBER
        FSB_UNPD_BAL, -- NUMBER
        ACS_NEW_BUS_COMM_PREM_AMT, -- NUMBER
        PLCY_FEE_CD, -- VARCHAR
        PLCY_FEE_AMT, -- NUMBER
        REINST_FEE_AMT, -- NUMBER
        ST_CHRG_AMT, -- NUMBER
        TRANS_PLCY_FEE_AMT, -- NUMBER
        TRANS_REINST_FEE_AMT, -- NUMBER
        ACS_PLCY_FEE_AMT, -- NUMBER
        ACS_REINST_FEE_AMT, -- NUMBER
        TRANS_ST_CHRG_AMT, -- NUMBER
        SLS_CNT_TTL_PD, -- NUMBER
        TRANS_SLS_CNT_PD, -- NUMBER
        EXP_DT, -- DATE
        ACS_RNCOMM_PREM_AMT, -- NUMBER
        FACESHEET_PRNT_DT, -- DATE
        TRANS_OPERTNG_COST, -- NUMBER
        ACS_NEW_BUS_COMM_AMT, -- NUMBER
        ACS_RNCOMM_AMT, -- NUMBER
        ACS_NEW_BUS_CITY_TAX_AMT, -- NUMBER
        ACS_NEW_BUS_CNTY_TAX_AMT, -- NUMBER
        ACS_NEW_BUS_SURCHRG_AMT, -- NUMBER
        ACS_NEW_BUS_CLCT_FEE, -- NUMBER
        ACS_RNWL_CITY_TAX_AMT, -- NUMBER
        ACS_RNWL_CNTY_TAX_AMT, -- NUMBER
        ACS_RNWL_SURCHRG_AMT, -- NUMBER
        ACS_RNWL_CLCT_FEE, -- NUMBER
        TRANS_BILL_TAX_AMT, -- NUMBER
        TRANS_SURCHRG_AMT, -- NUMBER
        TRANS_CLCT_FEE, -- NUMBER
        TRANS_PRORT_FCTR, -- NUMBER
        ROLLUP_PLCY_FEE, -- NUMBER
        ROLLUP_REINST_FEE, -- NUMBER
        MISC_AMT, -- NUMBER
        CAP_TERM_NUM, -- NUMBER
        RTG_CAP_CD, -- VARCHAR
        RTG_CAP_FCTR, -- NUMBER
        REVERSAL_OLD_FULL_TERM_PREM, -- NUMBER
        REVERSAL_NEW_FULL_TERM_PREM, -- NUMBER
        OFF_PREM_AMT, -- NUMBER
        ON_PREM_AMT, -- NUMBER
        REVERSAL_OFF_PREM_AMT, -- NUMBER
        REVERSAL_ON_PREM_AMT, -- NUMBER
        CR_BY_MAPNG_ID, -- NUMBER
        DW_CR_TMSP, -- TIMESTAMPNTZ
        UPD_BY_MAPNG_ID, -- NUMBER
        DW_UPD_TMSP, -- TIMESTAMPNTZ
        WRK_FLOW_RUN_ID, -- NUMBER
        SRC_TRANS_TMSP, -- TIMESTAMPNTZ
        SRC_HH_NUM, -- VARCHAR
        PROC_CD, -- VARCHAR
        MAJOR_SOI_ID, -- NUMBER
        ALTRN_PRORT_FCTR, -- NUMBER
        HAZARD_DIS_PCT, -- NUMBER
        FL_CPIC_EMERG_SURCHRG_AMT, -- NUMBER
        FL_CPIC_REG_ASSMNT_AMT, -- NUMBER
        FL_EMERG_PREP_ASSMNT_AMT, -- NUMBER
        FL_HURR_CAT_FUND_AMT, -- NUMBER
        FL_IGA_EMERG_AMT, -- NUMBER
        FL_IGA_REG_AMT, -- NUMBER
        MERG_TYP_CD, -- VARCHAR
        NON_RNWL_IND, -- VARCHAR
        NR_RVRSL_IND, -- VARCHAR
        SRC_SYS_CD, -- VARCHAR
        SRC_TRN_ID, -- VARCHAR
        TRANS_CITY_TAX_AMT, -- NUMBER
        TRANS_CNTY_TAX_AMT, -- NUMBER
        TRANS_CITY_TAX_FEE_AMT, -- NUMBER
        TRANS_CNTY_TAX_FEE_AMT, -- NUMBER
        TRANS_SURCHRG_FEE_AMT, -- NUMBER
        LA_CST_PLAN_REG_ASSMNT, -- NUMBER
        LA_CST_PLAN_EMERG_ASSMNT, -- NUMBER
        LA_FAIR_PLAN_REG_ASSMNT, -- NUMBER
        LA_FAIR_PLAN_EMERG_ASSMNT, -- NUMBER
        NCRB_PREM_AMT, -- NUMBER
        FRMS_NC_PREM_AMT, -- NUMBER
        CAT_RCVRY_CHRG_AMT, -- NUMBER
        FRMS_UNCPD_PREM_AMT, -- NUMBER
        BNDG_USR_ROLE_DESC, -- VARCHAR
        EVNT_INTIATD_BY_SHRT_DESC, -- VARCHAR
        ROLLUP_PLCY_FEE_AMT, -- NUMBER
        ROLLUP_RNSTTMNT_FEE_AMT, -- NUMBER
        RATE_CHNG_IND, -- VARCHAR
        FIGA_PRPTY_CRDT_AMT, -- NUMBER
        ACCM_TRN_NTRL_DISMIT_FEE, -- NUMBER
        TRN_NTRL_DISMIT_FEE -- NUMBER
    FROM {{ source('PRE_FDR', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}
)


-- Source node: SQ_FDR_LIB_STG_TFPLCY_TRAN_RESULT
, SQ_FDR_LIB_STG_TFPLCY_TRAN_RESULT AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK AS TFPLCY_TRAN_RESULT_SK, -- integer
        LAT_DATE AS LAT_DATE, -- date/time
        LAT_TIME AS LAT_TIME, -- date/time
        LAT_ACTION AS LAT_ACTION, -- string
        CR_BY_MAPNG_ID AS CR_BY_MAPNG_ID, -- integer
        DW_CR_TMSP AS DW_CR_TMSP, -- date/time
        UPD_BY_MAPNG_ID AS UPD_BY_MAPNG_ID, -- integer
        DW_UPD_TMSP AS DW_UPD_TMSP, -- date/time
        WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID, -- integer
        REPROC_CNT AS REPROC_CNT, -- integer
        POLICY_NUMBER AS POLICY_NUMBER, -- integer
        APPLIED_DTSTMP AS APPLIED_DTSTMP, -- date/time
        OLD_FT_PRM_AMT AS OLD_FT_PRM_AMT, -- decimal
        NEW_FT_PRM_AMT AS NEW_FT_PRM_AMT, -- decimal
        TRN_NBCOMM_PRM_AMT AS TRN_NBCOMM_PRM_AMT, -- decimal
        TRN_RNCOMM_PRM_AMT AS TRN_RNCOMM_PRM_AMT, -- decimal
        TRN_NBCOMM_PRO_AMT AS TRN_NBCOMM_PRO_AMT, -- decimal
        TRN_RNCOMM_PRO_AMT AS TRN_RNCOMM_PRO_AMT, -- decimal
        FSB_UNPAID_BALANCE AS FSB_UNPAID_BALANCE, -- decimal
        ACS_NBCOMM_PRM_AMT AS ACS_NBCOMM_PRM_AMT, -- decimal
        POLICY_FEE_CD AS POLICY_FEE_CD, -- string
        POLICY_FEE_AMT AS POLICY_FEE_AMT, -- decimal
        REINST_FEE_AMT AS REINST_FEE_AMT, -- decimal
        STATE_CHRG_AMT AS STATE_CHRG_AMT, -- decimal
        TRN_POLICY_FEE_AMT AS TRN_POLICY_FEE_AMT, -- decimal
        TRN_REINST_FEE_AMT AS TRN_REINST_FEE_AMT, -- decimal
        ACS_POLICY_FEE_AMT AS ACS_POLICY_FEE_AMT, -- decimal
        ACS_REINST_FEE_AMT AS ACS_REINST_FEE_AMT, -- decimal
        TRN_STATE_CHRG_AMT AS TRN_STATE_CHRG_AMT, -- decimal
        SALES_COUNT_TOT_PD AS SALES_COUNT_TOT_PD, -- small integer
        TRN_SALES_COUNT_PD AS TRN_SALES_COUNT_PD, -- small integer
        EFF_DT AS EFF_DT, -- date/time
        EXP_DT AS EXP_DT, -- date/time
        ACS_RNCOMM_PRM_AMT AS ACS_RNCOMM_PRM_AMT, -- decimal
        FACESHEET_PRINT_DT AS FACESHEET_PRINT_DT, -- date/time
        TRN_OPERATING_COST AS TRN_OPERATING_COST, -- decimal
        ACS_NB_COMM_AMT AS ACS_NB_COMM_AMT, -- decimal
        ACS_RN_COMM_AMT AS ACS_RN_COMM_AMT, -- decimal
        ACS_NB_CITY_TX_AMT AS ACS_NB_CITY_TX_AMT, -- decimal
        ACS_NB_CNTY_TX_AMT AS ACS_NB_CNTY_TX_AMT, -- decimal
        ACS_NB_SURCHG_AMT AS ACS_NB_SURCHG_AMT, -- decimal
        ACS_NB_CLCTN_FEE AS ACS_NB_CLCTN_FEE, -- decimal
        ACS_RN_CITY_TX_AMT AS ACS_RN_CITY_TX_AMT, -- decimal
        ACS_RN_CNTY_TX_AMT AS ACS_RN_CNTY_TX_AMT, -- decimal
        ACS_RN_SURCHG_AMT AS ACS_RN_SURCHG_AMT, -- decimal
        ACS_RN_CLCTN_FEE AS ACS_RN_CLCTN_FEE, -- decimal
        TRN_BILLED_TAX_AMT AS TRN_BILLED_TAX_AMT, -- decimal
        TRN_SURCHARGE_AMT AS TRN_SURCHARGE_AMT, -- decimal
        TRN_COLLECTION_FEE AS TRN_COLLECTION_FEE, -- decimal
        TRN_PRORATE_FACTOR AS TRN_PRORATE_FACTOR, -- decimal
        ROLLUP_POLICY_FEE AS ROLLUP_POLICY_FEE, -- decimal
        ROLLUP_REINST_FEE AS ROLLUP_REINST_FEE, -- decimal
        PRE_FDR_MAPNG_ID AS PRE_FDR_MAPNG_ID, -- integer
        MISC_AMT AS MISC_AMT, -- decimal
        RVRSL_OLD_FT_PRM AS RVRSL_OLD_FT_PRM, -- decimal
        RVRSL_NEW_FT_PRM AS RVRSL_NEW_FT_PRM, -- decimal
        OFF_PRM_AMT AS OFF_PRM_AMT, -- decimal
        ON_PRM_AMT AS ON_PRM_AMT, -- decimal
        RVRSL_OFF_PRM_AMT AS RVRSL_OFF_PRM_AMT, -- decimal
        RVRSL_ON_PRM_AMT AS RVRSL_ON_PRM_AMT, -- decimal
        CAP_TERM_NUM AS CAP_TERM_NUM, -- small integer
        RTG_CAP_CD AS RTG_CAP_CD, -- string
        RTG_CAP_FCTR AS RTG_CAP_FCTR, -- decimal
        HOUSEHOLD_NUM AS HOUSEHOLD_NUM, -- string
        ALT_PRORATE_FCTR AS ALT_PRORATE_FCTR, -- decimal
        HAZARD_DIS_PCT AS HAZARD_DIS_PCT -- decimal
    FROM {{ source('STG', 'STG_TFPLCY_TRAN_RESULT') }} A
    WHERE 
        A.PRE_FDR_MAPNG_ID = (
            SELECT WRKFL_MAPNG_ID 
            FROM {{ source('ABC', 'ABC_CTRL_WRKFL_MAPNG_PRMTR') }} 
            WHERE WRKFL_MAPNG_NM = '{{ var("MAPPING_NAME") }}' 
              AND WRKFL_INFA_FOLDER_NM = '{{ var("FOLDER_NAME") }}'
        ) 
        OR A.PRE_FDR_MAPNG_ID = 0
    ORDER BY 
        A.POLICY_NUMBER DESC,
        A.WRK_FLOW_RUN_ID DESC,
        A.EFF_DT DESC,
        A.APPLIED_DTSTMP DESC,
        A.LAT_DATE DESC,
        A.LAT_TIME DESC,
        CASE WHEN A.LAT_ACTION = 'U' THEN 1 ELSE 0 END DESC
)


-- Source node: SQ_FDR_LIB_ABC_BAL_ROW_COUNTS
, SQ_FDR_LIB_ABC_BAL_ROW_COUNTS AS (
    SELECT 
        'STG_TFPLCY_TRAN_RESULT' AS TRGT_TBL_NM,
        'FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT' AS SRC_TBL_NM,
        'T' AS RECRD_CNT_TYP_CD,
        'I' AS RECRD_CNT_ACTN_CD,
        COUNT(*) AS RECRD_CNT_QTY,
        wrk_flow_run_id AS WRKFL_RUN_ID,
        'Workflow_Name' AS WRKFL_NM,
        SUM(old_full_term_prem_amt) AS OLD_FULL_TERM_PREM_AMT,
        SUM(new_full_term_prem_amt) AS NEW_FULL_TERM_PREM_AMT,
        SUM(trans_new_bus_comm_prem_amt) AS TRANS_NEW_BUS_COMM_PREM_AMT,
        SUM(trans_rncomm_prem_amt) AS TRANS_RNCOMM_PREM_AMT,
        SUM(trans_new_bus_comm_pro_amt) AS TRANS_NEW_BUS_COMM_PRO_AMT,
        SUM(trans_rncomm_pro_amt) AS TRANS_RNCOMM_PRO_AMT,
        SUM(fsb_unpd_bal) AS FSB_UNPD_BAL,
        SUM(acs_new_bus_comm_prem_amt) AS ACS_NEW_BUS_COMM_PREM_AMT,
        SUM(plcy_fee_amt) AS PLCY_FEE_AMT,
        SUM(reinst_fee_amt) AS REINST_FEE_AMT,
        SUM(st_chrg_amt) AS ST_CHRG_AMT,
        SUM(trans_plcy_fee_amt) AS TRANS_PLCY_FEE_AMT,
        SUM(trans_reinst_fee_amt) AS TRANS_REINST_FEE_AMT,
        SUM(acs_plcy_fee_amt) AS ACS_PLCY_FEE_AMT,
        SUM(acs_reinst_fee_amt) AS ACS_REINST_FEE_AMT,
        SUM(trans_st_chrg_amt) AS TRANS_ST_CHRG_AMT,
        SUM(acs_rncomm_prem_amt) AS ACS_RNCOMM_PREM_AMT,
        SUM(trans_opertng_cost) AS TRANS_OPERTNG_COST,
        SUM(acs_new_bus_comm_amt) AS ACS_NEW_BUS_COMM_AMT,
        SUM(acs_rncomm_amt) AS ACS_RNCOMM_AMT,
        SUM(acs_new_bus_city_tax_amt) AS ACS_NEW_BUS_CITY_TAX_AMT,
        SUM(acs_new_bus_cnty_tax_amt) AS ACS_NEW_BUS_CNTY_TAX_AMT,
        SUM(acs_new_bus_surchrg_amt) AS ACS_NEW_BUS_SURCHRG_AMT,
        SUM(acs_new_bus_clct_fee) AS ACS_NEW_BUS_CLCT_FEE,
        SUM(acs_rnwl_city_tax_amt) AS ACS_RNWL_CITY_TAX_AMT,
        SUM(acs_rnwl_cnty_tax_amt) AS ACS_RNWL_CNTY_TAX_AMT,
        SUM(acs_rnwl_surchrg_amt) AS ACS_RNWL_SURCHRG_AMT,
        SUM(acs_rnwl_clct_fee) AS ACS_RNWL_CLCT_FEE,
        SUM(trans_bill_tax_amt) AS TRANS_BILL_TAX_AMT,
        SUM(trans_surchrg_amt) AS TRANS_SURCHRG_AMT,
        SUM(trans_clct_fee) AS TRANS_CLCT_FEE,
        SUM(rollup_plcy_fee) AS ROLLUP_PLCY_FEE,
        SUM(rollup_reinst_fee) AS ROLLUP_REINST_FEE,
        SUM(misc_amt) AS MISC_AMT,
        SUM(reversal_old_full_term_prem) AS REVERSAL_OLD_FULL_TERM_PREM,
        SUM(reversal_new_full_term_prem) AS REVERSAL_NEW_FULL_TERM_PREM,
        SUM(off_prem_amt) AS OFF_PREM_AMT,
        SUM(on_prem_amt) AS ON_PREM_AMT,
        SUM(reversal_off_prem_amt) AS REVERSAL_OFF_PREM_AMT,
        SUM(reversal_on_prem_amt) AS REVERSAL_ON_PREM_AMT
    FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    WHERE dw_cr_tmsp = (
        SELECT MAX(dw_upd_tmsp) 
        FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    )
    AND dw_cr_tmsp = dw_upd_tmsp
    AND wrk_flow_run_id = (
        SELECT MAX(wrkfl_run_id) 
        FROM {{ source('ABC', 'abc_audit_wrkfl_run') }} r
        JOIN {{ source('ABC', 'abc_ctrl_wrkfl_prmtr') }} p
        ON r.wrkfl_id = p.wrkfl_id
        WHERE p.wrkfl_nm = 'Workflow_Name'
    )
    GROUP BY wrk_flow_run_id

    UNION

    SELECT 
        'STG_TFPLCY_TRAN_RESULT' AS TRGT_TBL_NM,
        'FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT' AS SRC_TBL_NM,
        'T' AS RECRD_CNT_TYP_CD,
        'U' AS RECRD_CNT_ACTN_CD,
        COUNT(*) AS RECRD_CNT_QTY,
        wrk_flow_run_id AS WRKFL_RUN_ID,
        'Workflow_Name' AS WRKFL_NM,
        SUM(old_full_term_prem_amt) AS OLD_FULL_TERM_PREM_AMT,
        SUM(new_full_term_prem_amt) AS NEW_FULL_TERM_PREM_AMT,
        SUM(trans_new_bus_comm_prem_amt) AS TRANS_NEW_BUS_COMM_PREM_AMT,
        SUM(trans_rncomm_prem_amt) AS TRANS_RNCOMM_PREM_AMT,
        SUM(trans_new_bus_comm_pro_amt) AS TRANS_NEW_BUS_COMM_PRO_AMT,
        SUM(trans_rncomm_pro_amt) AS TRANS_RNCOMM_PRO_AMT,
        SUM(fsb_unpd_bal) AS FSB_UNPD_BAL,
        SUM(acs_new_bus_comm_prem_amt) AS ACS_NEW_BUS_COMM_PREM_AMT,
        SUM(plcy_fee_amt) AS PLCY_FEE_AMT,
        SUM(reinst_fee_amt) AS REINST_FEE_AMT,
        SUM(st_chrg_amt) AS ST_CHRG_AMT,
        SUM(trans_plcy_fee_amt) AS TRANS_PLCY_FEE_AMT,
        SUM(trans_reinst_fee_amt) AS TRANS_REINST_FEE_AMT,
        SUM(acs_plcy_fee_amt) AS ACS_PLCY_FEE_AMT,
        SUM(acs_reinst_fee_amt) AS ACS_REINST_FEE_AMT,
        SUM(trans_st_chrg_amt) AS TRANS_ST_CHRG_AMT,
        SUM(acs_rncomm_prem_amt) AS ACS_RNCOMM_PREM_AMT,
        SUM(trans_opertng_cost) AS TRANS_OPERTNG_COST,
        SUM(acs_new_bus_comm_amt) AS ACS_NEW_BUS_COMM_AMT,
        SUM(acs_rncomm_amt) AS ACS_RNCOMM_AMT,
        SUM(acs_new_bus_city_tax_amt) AS ACS_NEW_BUS_CITY_TAX_AMT,
        SUM(acs_new_bus_cnty_tax_amt) AS ACS_NEW_BUS_CNTY_TAX_AMT,
        SUM(acs_new_bus_surchrg_amt) AS ACS_NEW_BUS_SURCHRG_AMT,
        SUM(acs_new_bus_clct_fee) AS ACS_NEW_BUS_CLCT_FEE,
        SUM(acs_rnwl_city_tax_amt) AS ACS_RNWL_CITY_TAX_AMT,
        SUM(acs_rnwl_cnty_tax_amt) AS ACS_RNWL_CNTY_TAX_AMT,
        SUM(acs_rnwl_surchrg_amt) AS ACS_RNWL_SURCHRG_AMT,
        SUM(acs_rnwl_clct_fee) AS ACS_RNWL_CLCT_FEE,
        SUM(trans_bill_tax_amt) AS TRANS_BILL_TAX_AMT,
        SUM(trans_surchrg_amt) AS TRANS_SURCHRG_AMT,
        SUM(trans_clct_fee) AS TRANS_CLCT_FEE,
        SUM(rollup_plcy_fee) AS ROLLUP_PLCY_FEE,
        SUM(rollup_reinst_fee) AS ROLLUP_REINST_FEE,
        SUM(misc_amt) AS MISC_AMT,
        SUM(reversal_old_full_term_prem) AS REVERSAL_OLD_FULL_TERM_PREM,
        SUM(reversal_new_full_term_prem) AS REVERSAL_NEW_FULL_TERM_PREM,
        SUM(off_prem_amt) AS OFF_PREM_AMT,
        SUM(on_prem_amt) AS ON_PREM_AMT,
        SUM(reversal_off_prem_amt) AS REVERSAL_OFF_PREM_AMT,
        SUM(reversal_on_prem_amt) AS REVERSAL_ON_PREM_AMT
    FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    WHERE dw_upd_tmsp = (
        SELECT MAX(dw_upd_tmsp) 
        FROM {{ source('FDR', 'pre_fdr_fire_plcy_trans_rslt') }}
    )
    AND dw_upd_tmsp > dw_cr_tmsp
    AND wrk_flow_run_id = (
        SELECT MAX(wrkfl_run_id) 
        FROM {{ source('ABC', 'abc_audit_wrkfl_run') }} r
        JOIN {{ source('ABC', 'abc_ctrl_wrkfl_prmtr') }} p
        ON r.wrkfl_id = p.wrkfl_id
        WHERE p.wrkfl_nm = 'Workflow_Name'
    )
    GROUP BY wrk_flow_run_id
)


-- Source node: FDR_LIB_ABC_BAL_ROW_COUNTS1
, FDR_LIB_ABC_BAL_ROW_COUNTS1 AS (
    SELECT 
        BAL_ROW_COUNTS_SK AS BAL_ROW_COUNTS_SK, -- NUMBER
        TRGT_TBL_NM AS TRGT_TBL_NM, -- VARCHAR
        WRKFL_NM AS WRKFL_NM, -- VARCHAR
        WRKFL_CMPNT_NM AS WRKFL_CMPNT_NM, -- VARCHAR
        RECRD_CNT_TYP_CD AS RECRD_CNT_TYP_CD, -- VARCHAR
        RECRD_CNT_ACTN_CD AS RECRD_CNT_ACTN_CD, -- VARCHAR
        RECRD_CNT_QTY AS RECRD_CNT_QTY, -- NUMBER
        WRKFL_RUN_ID AS WRKFL_RUN_ID, -- NUMBER
        TRGT_TBL_WRKFL_CMPNT_OBJ_ID AS TRGT_TBL_WRKFL_CMPNT_OBJ_ID, -- NUMBER
        SRC_TBL_WRKFL_CMPNT_OBJ_ID AS SRC_TBL_WRKFL_CMPNT_OBJ_ID -- NUMBER
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: upd_ABC_BAL_DETAIL_AMTS_RP_INSERT
, upd_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
    SELECT 
        '0' AS BAL_ROW_COUNTS_SK, -- Update strategy expression applied
        '0' AS WRKFL_CMPNT_OBJ_ID, -- Update strategy expression applied
        '0' AS FIN_DETAIL_AMT -- Update strategy expression applied
)


-- Source node: upd_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
, upd_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
    SELECT 
        0 AS BAL_ROW_COUNTS_SK, -- Update strategy expression applied
        0 AS WRKFL_CMPNT_OBJ_ID, -- Update strategy expression applied
        0 AS FIN_DETAIL_AMT -- Update strategy expression applied
)


-- Source node: upd_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
, upd_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
    SELECT 
        0 AS BAL_ROW_COUNTS_SK, -- Transformation expression applied
        0 AS WRKFL_CMPNT_OBJ_ID, -- Transformation expression applied
        0 AS FIN_DETAIL_AMT -- Transformation expression applied
)


-- Transformation node: upd_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
, upd_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
    SELECT 
        '0' AS BAL_ROW_COUNTS_SK,  -- Update Strategy Expression set to '0' (DD_DELETE operation)
        '0' AS WRKFL_CMPNT_OBJ_ID, -- Update Strategy Expression set to '0' (DD_DELETE operation)
        '0' AS FIN_DETAIL_AMT      -- Update Strategy Expression set to '0' (DD_DELETE operation)
)


-- Transformation node: upd_FACESHEET_DT
, upd_FACESHEET_DT AS (
    SELECT 
        'DD_UPDATE' AS SRC_PLCY_ID_SK,
        'DD_UPDATE' AS SRC_INSERT_TRANS_TMSP,
        'DD_UPDATE' AS SRC_EFF_DT,
        'DD_UPDATE' AS o_DERIVED_FACESHEET_PRINT_DT,
        'DD_UPDATE' AS CR_BY_MAPNG_ID,
        'DD_UPDATE' AS DW_CR_TMSP,
        'DD_UPDATE' AS UPD_BY_MAPNG_ID,
        'DD_UPDATE' AS DW_UPD_TMSP,
        'DD_UPDATE' AS WRK_FLOW_RUN_ID
)


-- Transformation node: upd_INSERT
, upd_INSERT AS (
    SELECT 
        'DD_INSERT' AS TFPLCY_TRAN_RESULT_SK1,
        'DD_INSERT' AS LAT_DATE1,
        'DD_INSERT' AS LAT_TIME1,
        'DD_INSERT' AS LAT_ACTION1,
        'DD_INSERT' AS STG_CR_BY_MAPNG_ID1,
        'DD_INSERT' AS STG_DW_CR_TMSP1,
        'DD_INSERT' AS STG_UPD_BY_MAPNG_ID1,
        'DD_INSERT' AS STG_DW_UPD_TMSP1,
        'DD_INSERT' AS STG_WRK_FLOW_RUN_ID1,
        'DD_INSERT' AS POLICY_NUMBER1
)


{{ config(
    materialized='incremental',
    alias='FDR_FIRE_PLCY_TRANS_RSLT',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'PROC_CD',
        'o_RECRD_CNT_QTY',
        'TFPLCY_TRAN_RESULT_SK1',
        'LAT_DATE1',
        'LAT_TIME1',
        'LAT_ACTION1',
        'STG_CR_BY_MAPNG_ID1',
        'STG_DW_CR_TMSP1',
        'STG_UPD_BY_MAPNG_ID1'
    ]
) }}

final AS (
    SELECT
        'DD_INSERT' AS BAL_ROW_COUNTS_SK,
        'DD_INSERT' AS PROC_CD,
        'DD_INSERT' AS o_RECRD_CNT_QTY,
        'DD_INSERT' AS TFPLCY_TRAN_RESULT_SK1,
        'DD_INSERT' AS LAT_DATE1,
        'DD_INSERT' AS LAT_TIME1,
        'DD_INSERT' AS LAT_ACTION1,
        'DD_INSERT' AS STG_CR_BY_MAPNG_ID1,
        'DD_INSERT' AS STG_DW_CR_TMSP1,
        'DD_INSERT' AS STG_UPD_BY_MAPNG_ID1
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_CTRL_SYS_MSG',
    unique_key='STD_MSG_ID',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'ERR_DESC',
        'WRKFL_MAPNG_ID',
        'ERR_RESOLUTION_TMSP',
        'WRKFL_RUN_ID',
        'WRKFL_CMPNT_ID',
        'STD_MSG_ID',
        'ERR_STAT',
        'WRKFL_NM',
        'WRKFL_CMPNT_NM',
        'MSG_TMSP',
        'CMPNT_MODULE_NM',
        'CMPNT_MODULE_PK'
    ]
) }}

final AS (
    SELECT
        'DD_INSERT' AS ERR_DESC,
        'DD_INSERT' AS WRKFL_MAPNG_ID,
        'DD_INSERT' AS ERR_RESOLUTION_TMSP,
        'DD_INSERT' AS WRKFL_RUN_ID,
        'DD_INSERT' AS WRKFL_CMPNT_ID,
        'DD_INSERT' AS STD_MSG_ID,
        'DD_INSERT' AS ERR_STAT,
        'DD_INSERT' AS WRKFL_NM,
        'DD_INSERT' AS WRKFL_CMPNT_NM,
        'DD_INSERT' AS MSG_TMSP,
        'DD_INSERT' AS CMPNT_MODULE_NM,
        'DD_INSERT' AS CMPNT_MODULE_PK
)

SELECT * FROM final


-- Transformation node: exp_ASSIGN_ERROR_ID_AND_VALUES
, exp_ASSIGN_ERROR_ID_AND_VALUES AS (
    SELECT 
        WRKFL_NM,
        WRKFL_CMPNT_NM,
        CASE 
            WHEN v_RECORD_NUM IS NULL THEN 1 
            ELSE v_RECORD_NUM + 1 
        END AS v_RECORD_NUM,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN lkp_FDR_LIB_WRKFL_CMPNT_ID(WRKFL_CMPNT_NM) 
            ELSE v_WRKFL_CMPNT_ID 
        END AS v_WRKFL_CMPNT_ID,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN lkp_FDR_LIB_WORKFLOW_RUN_ID(WRKFL_NM) 
            ELSE v_WRKFL_RUN_ID 
        END AS v_WRKFL_RUN_ID,
        CASE 
            WHEN v_WRKFL_CMPNT_ID IS NULL THEN 0 
            ELSE v_WRKFL_CMPNT_ID 
        END AS WRKFL_CMPNT_ID,
        CASE 
            WHEN v_WRKFL_RUN_ID IS NULL THEN 0 
            ELSE v_WRKFL_RUN_ID 
        END AS WRKFL_RUN_ID,
        CASE 
            WHEN i_STD_MSG_ID IS NULL THEN 0 
            ELSE i_STD_MSG_ID 
        END AS STD_MSG_ID,
        CMPNT_MODULE_NM,
        ERR_DESC,
        SESSSTARTTIME AS o_MSG_TMSP,
        'OPEN' AS o_ERR_STAT,
        NULL AS o_ERR_RESOLUTION_TMSP,
        CMPNT_MODULE_PK,
        lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) AS o_WRKFL_MAPNG_ID
    FROM <PREVIOUS_NODE_NAME>
)


-- Transformation node: upd_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
, upd_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
    SELECT 
        0 AS BAL_ROW_COUNTS_SK,
        0 AS WRKFL_CMPNT_OBJ_ID,
        0 AS FIN_DETAIL_AMT
)


-- Target node: upd_UPD_GATE_KPR
{{ config(
    materialized='incremental',
    alias='upd_UPD_GATE_KPR',
    unique_key='TFPLCY_TRAN_RESULT_SK1',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'PRE_FDR_MAPNG_ID',
        'TFPLCY_TRAN_RESULT_SK1',
        'SRC_SYS_HH_NUM1',
        'SRC_TRANS_TMSP1',
        'LOB_CD1',
        'GATE_KPR_IND',
        'COMPONENT_MODULE_NAME1',
        'CR_BY_MAPNG_ID1',
        'DW_CR_TMSP1',
        'UPD_BY_MAPNG_ID1',
        'DW_UPD_TMSP1',
        'WRK_FLOW_RUN_ID1'
    ]
) }}

final AS (
    SELECT
        PRE_FDR_MAPNG_ID,
        TFPLCY_TRAN_RESULT_SK1,
        SRC_SYS_HH_NUM1,
        SRC_TRANS_TMSP1,
        LOB_CD1,
        GATE_KPR_IND,
        COMPONENT_MODULE_NAME1,
        CR_BY_MAPNG_ID1,
        DW_CR_TMSP1,
        UPD_BY_MAPNG_ID1,
        DW_UPD_TMSP1,
        WRK_FLOW_RUN_ID1
    FROM upd_UPD_GATE_KPR
)

SELECT * FROM final


-- Transformation node: upd_INS_GATE_KPR
, upd_INS_GATE_KPR AS (
    SELECT 
        'DD_INSERT' AS TFPLCY_TRAN_RESULT_SK6,
        'DD_INSERT' AS SRC_SYS_HH_NUM6,
        'DD_INSERT' AS SRC_TRANS_TMSP6,
        'DD_INSERT' AS COMPONENT_MODULE_NAME6,
        'DD_INSERT' AS LOB_CD6,
        'DD_INSERT' AS GATE_KPR_IND,
        'DD_INSERT' AS CR_BY_MAPNG_ID6,
        'DD_INSERT' AS DW_CR_TMSP6,
        'DD_INSERT' AS UPD_BY_MAPNG_ID6,
        'DD_INSERT' AS DW_UPD_TMSP6,
        'DD_INSERT' AS WRK_FLOW_RUN_ID6
)


-- Transformation node: upd_INSERT_ABC
, upd_INSERT_ABC AS (
    SELECT 
        'DD_INSERT' AS BAL_ROW_COUNTS_SK,
        'DD_INSERT' AS TRGT_TBL_NM,
        'DD_INSERT' AS SRC_TBL_NM,
        'DD_INSERT' AS WRKFL_CMPNT_NM,
        'DD_INSERT' AS RECRD_CNT_TYP_CD,
        'DD_INSERT' AS RECRD_CNT_ACTN_CD,
        'DD_INSERT' AS RECRD_CNT_QTY,
        'DD_INSERT' AS WRKFL_RUN_ID,
        'DD_INSERT' AS WRKFL_NM,
        'DD_INSERT' AS TRGT_TBL_WRKFL_CMPNT_OBJ_ID,
        'DD_INSERT' AS SRC_TBL_WRKFL_CMPNT_OBJ_ID
)


-- Transformation node: rtr_SPLITS
, rtr_SPLITS AS (
    SELECT 
        CASE 
            WHEN INSERT_IND = 1 AND DUP_FLAG <> 1 THEN TFPLCY_TRAN_RESULT_SK1
            WHEN UPDATE_IND = 1 AND DUP_FLAG <> 1 THEN TFPLCY_TRAN_RESULT_SK3
            WHEN REPROC_FLAG = 1 OR DUP_FLAG = 1 THEN TFPLCY_TRAN_RESULT_SK4
            WHEN ERROR_IND = 1 OR DUP_FLAG = 1 THEN TFPLCY_TRAN_RESULT_SK5
            WHEN REPROC_TYP_CD = 'F' AND REPROC_FLAG = 1 AND PRE_FDR_MAPNG_ID = 0 THEN TFPLCY_TRAN_RESULT_SK6
            ELSE TFPLCY_TRAN_RESULT_SK2
        END AS TFPLCY_TRAN_RESULT_SK
    FROM <PREVIOUS_NODE_NAME>
)


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'REPROC_TYP_CD',
        'WORKFLOW_NAME4',
        'WORKFLOW_COMPONENT_NAME4',
        'WRK_FLOW_RUN_ID4',
        'RECRD_CNT_TYP_ACTN_CD',
        'RECRD_CNT_TYP_CD',
        'REPROC_TARGET_TABLE_NAME',
        'o_RECRD_CNT_QTY',
        'SOURCE_TABLE_NAME4',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        'DD_INSERT' AS BAL_ROW_COUNTS_SK,
        'DD_INSERT' AS REPROC_TYP_CD,
        'DD_INSERT' AS WORKFLOW_NAME4,
        'DD_INSERT' AS WORKFLOW_COMPONENT_NAME4,
        'DD_INSERT' AS WRK_FLOW_RUN_ID4,
        'DD_INSERT' AS RECRD_CNT_TYP_ACTN_CD,
        'DD_INSERT' AS RECRD_CNT_TYP_CD,
        'DD_INSERT' AS REPROC_TARGET_TABLE_NAME,
        'DD_INSERT' AS o_RECRD_CNT_QTY,
        'DD_INSERT' AS SOURCE_TABLE_NAME4,
        'DD_INSERT' AS TRGT_TBL_WRKFL_CMPNT_OBJ_ID,
        'DD_INSERT' AS SRC_TBL_WRKFL_CMPNT_OBJ_ID
)

SELECT * FROM final


-- Source node: upd_ABC_BAL_ROW_COUNTS_SOURCE_INSERT_UPDATE
, upd_ABC_BAL_ROW_COUNTS_SOURCE_INSERT_UPDATE AS (
    SELECT 
        'DD_INSERT' AS BAL_ROW_COUNTS_SK,
        'DD_INSERT' AS PROC_CD3,
        'DD_INSERT' AS o_RECRD_CNT_QTY,
        'DD_INSERT' AS RECRD_CNT_TYP_CD_INS3,
        'DD_INSERT' AS RECRD_CNT_TYP_ACTN_INS3,
        'DD_INSERT' AS WORKFLOW_NAME3,
        'DD_INSERT' AS TARGET_TABLE_NAME3,
        'DD_INSERT' AS SOURCE_TABLE_NAME3,
        'DD_INSERT' AS WRK_FLOW_RUN_ID3,
        'DD_INSERT' AS WORKFLOW_COMPONENT_NAME3,
        'DD_INSERT' AS TRGT_TBL_WRKFL_CMPNT_OBJ_ID,
        'DD_INSERT' AS SRC_TBL_WRKFL_CMPNT_OBJ_ID
)


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS2',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'PROC_CD',
        'PRE_FDR_MAPNG_ID',
        'WORKFLOW_NAME1',
        'WORKFLOW_COMPONENT_NAME1',
        'TARGET_TABLE_NAME1',
        'SOURCE_TABLE_NAME1',
        'WRK_FLOW_RUN_ID1',
        'RECRD_CNT_TYP_ACTN_INS1',
        'RECRD_CNT_TYP_CD_RP_INS',
        'o_RECRD_CNT_QTY',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        BAL_ROW_COUNTS_SK,
        PROC_CD,
        PRE_FDR_MAPNG_ID,
        WORKFLOW_NAME1,
        WORKFLOW_COMPONENT_NAME1,
        TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1,
        WRK_FLOW_RUN_ID1,
        RECRD_CNT_TYP_ACTN_INS1,
        RECRD_CNT_TYP_CD_RP_INS,
        o_RECRD_CNT_QTY,
        SRC_TBL_WRKFL_CMPNT_OBJ_ID,
        TRGT_TBL_WRKFL_CMPNT_OBJ_ID
    FROM upd_ABC_BAL_ROW_COUNTS2
)

SELECT * FROM final


-- Lookup transformation node: lkp_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_TBL_OBJ_ID
, lkp_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_TBL_OBJ_ID AS (
    SELECT 
        a.WRKFL_CMPNT_OBJ_ID AS TRGT_TBL_WRKFL_CMPNT_OBJ_ID,
        b.WRKFL_CMPNT_OBJ_ID AS SRC_TBL_WRKFL_CMPNT_OBJ_ID,
        a.OBJ_TBL_NM AS TRGT_TBL_NM,
        b.OBJ_TBL_NM AS SRC_TBL_NM
    FROM 
        ABC_CTRL_WRKFL_CMPNT_OBJ a
    JOIN 
        ABC_CTRL_WRKFL_CMPNT_OBJ b
    ON 
        a.WRKFL_CMPNT_SRC_OBJ_ID = b.WRKFL_CMPNT_OBJ_ID
    WHERE 
        a.WRKFL_OBJ_TYP_CD = 'T'
)


-- Transformation node: seq_ABC_BAL_ROW_COUNTS_SK
, seq_ABC_BAL_ROW_COUNTS_SK AS (
    SELECT 
        -- Generate NEXTVAL based on sequence configuration
        GENERATE_SERIES(0, 9223372036854775807, 1) AS NEXTVAL,
        
        -- CURRVAL based on the current value in sequence configuration
        1516145001 AS CURRVAL
)


-- Transformation node: exp_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
, exp_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        'OLD_FT_PRM_AMT' AS TRGT_OLD_FULL_TERM_PREM_AMT,
        'NEW_FT_PRM_AMT' AS TRGT_NEW_FULL_TERM_PREM_AMT,
        'TRN_NBCOMM_PRM_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PREM_AMT,
        'TRN_RNCOMM_PRM_AMT' AS TRGT_TRANS_RNCOMM_PREM_AMT,
        'TRN_NBCOMM_PRO_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PRO_AMT,
        'TRN_RNCOMM_PRO_AMT' AS TRGT_TRANS_RNCOMM_PRO_AMT,
        'FSB_UNPAID_BALANCE' AS TRGT_FSB_UNPD_BAL
    FROM <PREVIOUS_NODE_NAME>
)


-- Transformation node: exp_NORM_ABC_BAL_DETAIL_AMTS_RP_INSERT
, exp_NORM_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        TRGT_COL_NM,
        SRC_COL_NM,
        -- Lookup logic for WRKFL_CMPNT_OBJ_ID
        LKP.LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID(TRGT_TBL_NM, SRC_TBL_NM, TRGT_COL_NM, SRC_COL_NM) AS WRKFL_CMPNT_OBJ_ID,
        FIN_DETAIL_AMT,
        -- Metadata fields
        'm_FDR_FIRE_PLCY_TRANS_RSLT_PL' AS mapping_name,
        'Normal' AS tracing_level,
        'Narinder Tiwari' AS author,
        '23 Sep 2011' AS creation_date
    FROM <PREVIOUS_NODE_NAME>
)


-- Lookup transformation node: lkp_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT
, lkp_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT AS (
    SELECT 
        a.PLCY_ID_SK AS PLCY_ID_SK,
        MIN(a.EFF_DT) AS EFF_DT
    FROM FDR.FDR_FIRE_PLCY_TRANS_RSLT a
    GROUP BY 
        a.PLCY_ID_SK
)


-- Lookup transformation node: lkp_FDR_FIRE_PLCY_TRANS_RSLT_LOW
, lkp_FDR_FIRE_PLCY_TRANS_RSLT_LOW AS (
    SELECT 
        A.PLCY_ID_SK AS PLCY_ID_SK,
        A.TRANS_TMSP AS TRANS_TMSP,
        A.EFF_DT AS EFF_DT,
        A.END_EFF_DT AS END_EFF_DT
    FROM {{ source('FDR', 'FDR_FIRE_PLCY_TRANS_RSLT') }} A
    WHERE A.END_EFF_DT > '1800-01-01'
      AND A.PLCY_ID_SK IN (
          SELECT PLCY_ID_SK
          FROM {{ source('FDR', 'FDR_PARENT_PLCY') }} B
          WHERE B.SRC_SYS_PLCY_NUM IN (
              SELECT POLICY_NUMBER
              FROM {{ source('STG', 'STG_TFPLCY_TRAN_RESULT') }}
          )
      )
)


-- Transformation node: exp_DATE_LOGIC
, exp_DATE_LOGIC AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK,  -- Passthrough field
        LAT_DATE,               -- Passthrough field
        CASE 
            WHEN TRN_NBCOMM_PRM_AMT >= -50000 AND TRN_NBCOMM_PRM_AMT <= 50000 THEN 0 
            ELSE 1 
        END AS v_TRN_NBCOMM_PRM_AMT_IND,  -- Derived field with conditional logic
        TO_DATE(
            TO_CHAR(LAT_DATE, 'MM/DD/YYYY') || ' ' || TO_CHAR(LAT_TIME, 'HH24:MI:SS'), 
            'MM/DD/YYYY HH24:MI:SS'
        ) AS v_LAT_DATE,  -- Derived field with date transformation
        v_LAT_DATE AS o_LAT_DATE,  -- Output field derived from intermediate variable
        CASE 
            WHEN (v_DUP_TGT_IND = 1 AND v_INSERT_TRANS_TMSP = TRANS_TMSP_LOW) 
                 OR DEDUP_FLAG = 1 
                 OR v_DUP_TGT_EXP_IND = 1 THEN '3'
            WHEN ISNULL(PLCY_ID_SK) OR ISNULL(SRC_SYS_HH_NUM) THEN '8'
            WHEN v_CLEANISING_IND = 1 THEN '2'
            ELSE NULL
        END AS v_SRC_SYS_MSG_CD,  -- Derived field with complex conditional logic
        v_ERR_MESG AS ERROR_MESG  -- Output field derived from intermediate variable
    FROM <PREVIOUS_NODE_NAME>  -- Replace with the actual previous node name
)


-- Source node: exp_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
, exp_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK, -- Primary key for balance row counts
        TRGT_TBL_NM,       -- Target table name
        SRC_TBL_NM,        -- Source table name
        'OLD_FULL_TERM_PREM_AMT' AS TRGT_OLD_FULL_TERM_PREM_AMT, -- Old full-term premium amount
        'NEW_FULL_TERM_PREM_AMT' AS TRGT_NEW_FULL_TERM_PREM_AMT, -- New full-term premium amount
        'TRANS_NEW_BUS_COMM_PREM_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PREM_AMT, -- Transaction new business commission premium amount
        'TRANS_RNCOMM_PREM_AMT' AS TRGT_TRANS_RNCOMM_PREM_AMT, -- Transaction renewal commission premium amount
        'TRANS_NEW_BUS_COMM_PRO_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PRO_AMT, -- Transaction new business commission pro amount
        'TRANS_RNCOMM_PRO_AMT' AS TRGT_TRANS_RNCOMM_PRO_AMT, -- Transaction renewal commission pro amount
        'FSB_UNPD_BAL' AS TRGT_FSB_UNPD_BAL -- FSB unpaid balance
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: exp_DEDUP
, exp_DEDUP AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK,
        LAT_DATE,
        LAT_TIME,
        LAT_ACTION,
        STG_CR_BY_MAPNG_ID,
        STG_DW_CR_TMSP,
        CASE 
            WHEN POLICY_NUMBER = v_POLICY_NUMBER_PREV 
                 AND EFF_DT = v_EFF_DT_PREV 
                 AND STG_WRK_FLOW_RUN_ID = v_STG_WRK_FLOW_RUN_ID_PREV 
                 AND APPLIED_DTSTMP = v_APPLIED_DTSTMP_PREV 
            THEN 1 
            ELSE 0 
        END AS v_DEDUP_FLAG,
        CASE 
            WHEN ISNULL(v_PLCY_ID_SK_DEP) 
            THEN :LKP.lkp_FDR_LIB_FDR_FIRE_PROP_STRUCTURE_MAJOR_SOI_ID_TRNS_RSLT(v_PLCY_ID_SK, v_SRC_SYS_CD) 
            ELSE :LKP.lkp_FDR_LIB_FDR_FIRE_PROP_STRUCTURE_MAJOR_SOI_ID_TRNS_RSLT(v_PLCY_ID_SK_DEP, v_SRC_SYS_CD) 
        END AS v_MAJOR_SOI_ID
    FROM <PREVIOUS_NODE_NAME>
)


-- Aggregator transformation: agg_COUNT_REPROCESSED_ROWS
, agg_COUNT_REPROCESSED_ROWS AS (
    SELECT 
        PROC_CD,
        PRE_FDR_MAPNG_ID,
        WORKFLOW_NAME1,
        WORKFLOW_COMPONENT_NAME1,
        TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1,
        WRK_FLOW_RUN_ID1,
        'RP' AS RECRD_CNT_TYP_CD_RP_INS, -- Constant value for record count type code
        COUNT(*) AS o_RECRD_CNT_QTY      -- Aggregated count of rows
    FROM <PREVIOUS_NODE_NAME>           -- Replace with actual previous node name
    GROUP BY 
        PROC_CD,
        PRE_FDR_MAPNG_ID,
        WORKFLOW_NAME1,
        WORKFLOW_COMPONENT_NAME1,
        TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1,
        WRK_FLOW_RUN_ID1
)


-- Source node: nrm_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
, nrm_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK, -- BAL_ROW_COUNTS_SK is normalized into multiple occurrences.
        TRGT_OBJ_TBL_NM,   -- TRGT_OBJ_TBL_NM is normalized into multiple occurrences.
        SRC_OBJ_TBL_NM,    -- SRC_OBJ_TBL_NM is normalized into multiple occurrences.
        TRGT_OBJ_COL_NM,   -- TRGT_OBJ_COL_NM is normalized into multiple occurrences.
        SRC_OBJ_COL_NM,    -- SRC_OBJ_COL_NM is normalized into multiple occurrences.
        FIN_DETAIL_AMT,    -- FIN_DETAIL_AMT is normalized into multiple occurrences.
        1 AS GK_BAL_ROW_COUNTS_SK, -- Generated key for BAL_ROW_COUNTS_SK with sequence generator value 1.
        NULL AS GCID_BAL_ROW_COUNTS_SK, -- Generated column ID for BAL_ROW_COUNTS_SK.
        NULL AS GCID_TRGT_OBJ_TBL_NM,   -- Generated column ID for TRGT_OBJ_TBL_NM.
        NULL AS GCID_SRC_OBJ_TBL_NM,    -- Generated column ID for SRC_OBJ_TBL_NM.
        NULL AS GCID_TRGT_OBJ_COL_NM,   -- Generated column ID for TRGT_OBJ_COL_NM.
        NULL AS GCID_SRC_OBJ_COL_NM,    -- Generated column ID for SRC_OBJ_COL_NM.
        NULL AS GCID_FIN_DETAIL_AMT     -- Generated column ID for FIN_DETAIL_AMT.
    FROM {{ source('FIRE_POLICY', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: exp_ABC_BAL_ROW_COUNTS_AND_AMTS_REPROC_INSERT
, exp_ABC_BAL_ROW_COUNTS_AND_AMTS_REPROC_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        o_OLD_FT_PRM_AMT1,
        o_NEW_FT_PRM_AMT1,
        o_TRN_NBCOMM_PRM_AMT1,
        o_TRN_RNCOMM_PRM_AMT1,
        o_TRN_NBCOMM_PRO_AMT1,
        o_TRN_RNCOMM_PRO_AMT1,
        o_FSB_UNPAID_BALANCE1,
        TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1
)


-- Aggregator transformation: agg_COUNT_SOURCE_UPDATE
, agg_COUNT_SOURCE_UPDATE AS (
    SELECT 
        PROC_CD3 AS PROC_CD3,
        COUNT(*) AS o_RECRD_CNT_QTY,
        RECRD_CNT_TYP_CD_INS3 AS RECRD_CNT_TYP_CD_INS3,
        PROC_CD3 AS RECRD_CNT_TYP_ACTN_INS3,
        WORKFLOW_NAME3 AS WORKFLOW_NAME3,
        TARGET_TABLE_NAME3 AS TARGET_TABLE_NAME3,
        SOURCE_TABLE_NAME3 AS SOURCE_TABLE_NAME3,
        WRK_FLOW_RUN_ID3 AS WRK_FLOW_RUN_ID3,
        WORKFLOW_COMPONENT_NAME3 AS WORKFLOW_COMPONENT_NAME3,
        OLD_FT_PRM_AMT3 AS OLD_FT_PRM_AMT3
    FROM {{ source('FIRE_POLICY', 'ABC_BAL_ROW_COUNTS') }}
    GROUP BY 
        PROC_CD3,
        RECRD_CNT_TYP_CD_INS3,
        WORKFLOW_NAME3,
        TARGET_TABLE_NAME3,
        SOURCE_TABLE_NAME3,
        WRK_FLOW_RUN_ID3,
        WORKFLOW_COMPONENT_NAME3,
        OLD_FT_PRM_AMT3
)


-- Transformation node: exp_ABC_BAL_DETAIL_AMTS_RP_INSERT
, exp_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        'OLD_FULL_TERM_PREM_AMT' AS TRGT_OLD_FULL_TERM_PREM_AMT,
        'NEW_FULL_TERM_PREM_AMT' AS TRGT_NEW_FULL_TERM_PREM_AMT,
        'TRANS_NEW_BUS_COMM_PREM_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PREM_AMT,
        'TRANS_RNCOMM_PREM_AMT' AS TRGT_TRANS_RNCOMM_PREM_AMT,
        'TRANS_NEW_BUS_COMM_PRO_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PRO_AMT,
        'TRANS_RNCOMM_PRO_AMT' AS TRGT_TRANS_RNCOMM_PRO_AMT,
        'FSB_UNPD_BAL' AS TRGT_FSB_UNPD_BAL
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Normalizer transformation node: nrm_ABC_BAL_DETAIL_AMTS_RP_INSERT
, nrm_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK AS BAL_ROW_COUNTS_SK, -- Normalized into multiple occurrences
        TRGT_OBJ_TBL_NM AS TRGT_OBJ_TBL_NM, -- Normalized into multiple occurrences
        SRC_OBJ_TBL_NM AS SRC_OBJ_TBL_NM, -- Normalized into multiple occurrences
        TRGT_OBJ_COL_NM AS TRGT_OBJ_COL_NM, -- Normalized into multiple occurrences
        SRC_OBJ_COL_NM AS SRC_OBJ_COL_NM, -- Normalized into multiple occurrences
        FIN_DETAIL_AMT AS FIN_DETAIL_AMT, -- Normalized into multiple occurrences
        CONCAT('GK_', BAL_ROW_COUNTS_SK) AS GK_BAL_ROW_COUNTS_SK, -- Generated key based on BAL_ROW_COUNTS_SK
        CONCAT('GCID_', BAL_ROW_COUNTS_SK) AS GCID_BAL_ROW_COUNTS_SK, -- Generated column ID based on BAL_ROW_COUNTS_SK
        CONCAT('GCID_', TRGT_OBJ_TBL_NM) AS GCID_TRGT_OBJ_TBL_NM, -- Generated column ID based on TRGT_OBJ_TBL_NM
        CONCAT('GCID_', SRC_OBJ_TBL_NM) AS GCID_SRC_OBJ_TBL_NM, -- Generated column ID based on SRC_OBJ_TBL_NM
        CONCAT('GCID_', TRGT_OBJ_COL_NM) AS GCID_TRGT_OBJ_COL_NM, -- Generated column ID based on TRGT_OBJ_COL_NM
        CONCAT('GCID_', SRC_OBJ_COL_NM) AS GCID_SRC_OBJ_COL_NM, -- Generated column ID based on SRC_OBJ_COL_NM
        CONCAT('GCID_', FIN_DETAIL_AMT) AS GCID_FIN_DETAIL_AMT -- Generated column ID based on FIN_DETAIL_AMT
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: exp_LOOKUP_CODES
, exp_LOOKUP_CODES AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK,
        LAT_DATE,
        LAT_TIME,
        LAT_ACTION,
        STG_CR_BY_MAPNG_ID,
        STG_DW_CR_TMSP,
        STG_UPD_BY_MAPNG_ID,
        STG_DW_UPD_TMSP,
        STG_WRK_FLOW_RUN_ID
    FROM STG_TFPLCY_TRAN_RESULT
)


-- Transformation node: exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
, exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        TRGT_COL_NM,
        SRC_COL_NM,
        -- Lookup logic for WRKFL_CMPNT_OBJ_ID
        COALESCE(
            LKP.LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID(TRGT_TBL_NM, SRC_TBL_NM, TRGT_COL_NM, SRC_COL_NM),
            NULL
        ) AS WRKFL_CMPNT_OBJ_ID,
        FIN_DETAIL_AMT
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: flt_SRC_DUP
, flt_SRC_DUP AS (
    SELECT 
        SRC_PLCY_ID_SK,
        SRC_INSERT_TRANS_TMSP,
        SRC_EFF_DT,
        o_DERIVED_FACESHEET_PRINT_DT,
        o_UPD_FLAG,
        CR_BY_MAPNG_ID,
        DW_CR_TMSP,
        UPD_BY_MAPNG_ID,
        DW_UPD_TMSP,
        WRK_FLOW_RUN_ID
    FROM <PREVIOUS_NODE_NAME>
    WHERE o_UPD_FLAG = 1
)


-- Transformation node: exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
, exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        TRGT_COL_NM,
        SRC_COL_NM,
        -- Lookup logic for WRKFL_CMPNT_OBJ_ID
        COALESCE(
            LKP.LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID(TRGT_TBL_NM, SRC_TBL_NM, TRGT_COL_NM, SRC_COL_NM),
            NULL
        ) AS WRKFL_CMPNT_OBJ_ID,
        FIN_DETAIL_AMT
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Aggregator transformation: agg_COUNT_SOURCE_INSERT
, agg_COUNT_SOURCE_INSERT AS (
    SELECT 
        PROC_CD_INS1 AS PROC_CD_INS1,
        WORKFLOW_COMPONENT_NAME1 AS WORKFLOW_COMPONENT_NAME1,
        WORKFLOW_NAME1 AS WORKFLOW_NAME1,
        WRK_FLOW_RUN_ID1 AS WRK_FLOW_RUN_ID1,
        RECRD_CNT_TYP_CD_INS1 AS RECRD_CNT_TYP_CD_INS1,
        RECRD_CNT_TYP_ACTN_INS1 AS RECRD_CNT_TYP_ACTN_INS1,
        TARGET_TABLE_NAME1 AS TARGET_TABLE_NAME1,
        COUNT(*) AS o_RECRD_CNT_QTY
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
    GROUP BY 
        PROC_CD_INS1,
        WORKFLOW_COMPONENT_NAME1,
        WORKFLOW_NAME1,
        WRK_FLOW_RUN_ID1,
        RECRD_CNT_TYP_CD_INS1,
        RECRD_CNT_TYP_ACTN_INS1,
        TARGET_TABLE_NAME1
)


-- Transformation node: agg_INS_GATE_KPR
, agg_INS_GATE_KPR AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK6,
        SRC_SYS_HH_NUM6,
        SRC_TRANS_TMSP6,
        COMPONENT_MODULE_NAME6,
        LOB_CD6,
        'N' AS GATE_KPR_IND, -- Default value for gatekeeper indicator
        CR_BY_MAPNG_ID6,
        DW_CR_TMSP6,
        UPD_BY_MAPNG_ID6,
        DW_UPD_TMSP6,
        WRK_FLOW_RUN_ID6
    FROM <PREVIOUS_NODE_NAME> -- Replace with the actual previous node name when known
)


-- Transformation node: fil_UPD_GATE_KPR
, fil_UPD_GATE_KPR AS (
    SELECT 
        PRE_FDR_MAPNG_ID,
        TFPLCY_TRAN_RESULT_SK1,
        SRC_SYS_HH_NUM1,
        SRC_TRANS_TMSP1,
        LOB_CD1,
        COMPONENT_MODULE_NAME1,
        CR_BY_MAPNG_ID1,
        DW_CR_TMSP1,
        UPD_BY_MAPNG_ID1,
        DW_UPD_TMSP1,
        WRK_FLOW_RUN_ID1
    FROM <PREVIOUS_NODE_NAME>
    WHERE PRE_FDR_MAPNG_ID > 0
)


-- Transformation node: exp_NORM_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
, exp_NORM_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        TRGT_COL_NM,
        SRC_COL_NM,
        -- Lookup logic for WRKFL_CMPNT_OBJ_ID
        COALESCE(
            LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID(TRGT_TBL_NM, SRC_TBL_NM, TRGT_COL_NM, SRC_COL_NM),
            NULL
        ) AS WRKFL_CMPNT_OBJ_ID,
        FIN_DETAIL_AMT,
        -- Metadata fields
        'm_FDR_FIRE_PLCY_TRANS_RSLT_PL' AS mapping_name,
        'Narinder Tiwari' AS author,
        '23 Sep 2011' AS creation_date
    FROM <PREVIOUS_NODE_NAME>
)


-- Lookup transformation: lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_APLD_DT
, lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_APLD_DT AS (
    SELECT 
        A.PLCY_ID_SK AS PLCY_ID_SK,
        A.TRANS_TMSP AS TRANS_TMSP,
        A.EFF_DT AS EFF_DT,
        A.FACESHEET_PRNT_DT AS FACESHEET_PRNT_DT,
        i_PLCY_ID_SK AS i_PLCY_ID_SK,
        i_TRANS_TMSP AS i_TRANS_TMSP,
        i_EFF_DT AS i_EFF_DT
    FROM $$FDR.FDR_FIRE_PLCY_TRANS_RSLT A
    WHERE A.PLCY_ID_SK IN (
        SELECT PLCY_ID_SK
        FROM $$FDR.FDR_PARENT_PLCY B
        WHERE B.SRC_SYS_PLCY_NUM IN (
            SELECT POLICY_NUMBER 
            FROM $$STG.STG_TFPLCY_TRAN_RESULT
        )
    )
    AND A.PLCY_ID_SK = i_PLCY_ID_SK 
    AND A.TRANS_TMSP = i_TRANS_TMSP 
    AND A.EFF_DT = i_EFF_DT
)


-- Transformation node: exp_ABC_BAL_ROW_COUNTS_AND_AMTS_RP_INSERT
, exp_ABC_BAL_ROW_COUNTS_AND_AMTS_RP_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        o_OLD_FT_PRM_AMT1,
        o_NEW_FT_PRM_AMT1,
        o_TRN_NBCOMM_PRM_AMT1,
        o_TRN_RNCOMM_PRM_AMT1,
        o_TRN_NBCOMM_PRO_AMT1,
        o_TRN_RNCOMM_PRO_AMT1,
        o_FSB_UNPAID_BALANCE1,
        TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1
    FROM <PREVIOUS_NODE_NAME>
)


-- Lookup transformation: lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_LAT_DT
, lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_LAT_DT AS (
    SELECT 
        A.PLCY_ID_SK AS PLCY_ID_SK,
        A.TRANS_TMSP AS TRANS_TMSP,
        A.EFF_DT AS EFF_DT,
        A.FACESHEET_PRNT_DT AS FACESHEET_PRNT_DT
    FROM {{ source('FDR', 'FDR_FIRE_PLCY_TRANS_RSLT') }} A
    WHERE A.PLCY_ID_SK IN (
        SELECT PLCY_ID_SK
        FROM {{ source('FDR', 'FDR_PARENT_PLCY') }} B
        WHERE B.SRC_SYS_PLCY_NUM IN (
            SELECT POLICY_NUMBER 
            FROM {{ source('STG', 'STG_TFPLCY_TRAN_RESULT') }}
        )
    )
)


-- Aggregator transformation: agg_COUNT_SOURCE_UPDATE_INSERT
, agg_COUNT_SOURCE_UPDATE_INSERT AS (
    SELECT 
        TFPLCY_TRAN_RESULT_SK3 AS TFPLCY_TRAN_RESULT_SK3,
        LAT_DATE3 AS LAT_DATE3,
        LAT_TIME3 AS LAT_TIME3,
        LAT_ACTION3 AS LAT_ACTION3,
        STG_CR_BY_MAPNG_ID3 AS STG_CR_BY_MAPNG_ID3,
        STG_DW_CR_TMSP3 AS STG_DW_CR_TMSP3,
        STG_UPD_BY_MAPNG_ID3 AS STG_UPD_BY_MAPNG_ID3,
        STG_DW_UPD_TMSP3 AS STG_DW_UPD_TMSP3,
        STG_WRK_FLOW_RUN_ID3 AS STG_WRK_FLOW_RUN_ID3,
        POLICY_NUMBER3 AS POLICY_NUMBER3,
        APPLIED_DTSTMP3 AS APPLIED_DTSTMP3,
        MIN(UPDATE_END_EFF_DT3) AS min_UPDATE_END_EFF_DT
    FROM <PREVIOUS_NODE_NAME>
    GROUP BY 
        TFPLCY_TRAN_RESULT_SK3,
        LAT_DATE3,
        LAT_TIME3,
        LAT_ACTION3,
        STG_CR_BY_MAPNG_ID3,
        STG_DW_CR_TMSP3,
        STG_UPD_BY_MAPNG_ID3,
        STG_DW_UPD_TMSP3,
        STG_WRK_FLOW_RUN_ID3,
        POLICY_NUMBER3,
        APPLIED_DTSTMP3
)


-- Normalizer transformation: nrm_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
, nrm_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
    SELECT 
        BAL_ROW_COUNTS_SK AS BAL_ROW_COUNTS_SK, -- Normalized into multiple occurrences
        TRGT_OBJ_TBL_NM AS TRGT_OBJ_TBL_NM, -- Normalized into multiple occurrences
        SRC_OBJ_TBL_NM AS SRC_OBJ_TBL_NM, -- Normalized into multiple occurrences
        TRGT_OBJ_COL_NM AS TRGT_OBJ_COL_NM, -- Normalized into multiple occurrences
        SRC_OBJ_COL_NM AS SRC_OBJ_COL_NM, -- Normalized into multiple occurrences
        FIN_DETAIL_AMT AS FIN_DETAIL_AMT, -- Normalized into multiple occurrences
        'Generated key for BAL_ROW_COUNTS_SK' AS GK_BAL_ROW_COUNTS_SK, -- Generated key
        'Generated column ID for BAL_ROW_COUNTS_SK' AS GCID_BAL_ROW_COUNTS_SK, -- Generated column ID
        'Generated column ID for TRGT_OBJ_TBL_NM' AS GCID_TRGT_OBJ_TBL_NM, -- Generated column ID
        'Generated column ID for SRC_OBJ_TBL_NM' AS GCID_SRC_OBJ_TBL_NM, -- Generated column ID
        'Generated column ID for TRGT_OBJ_COL_NM' AS GCID_TRGT_OBJ_COL_NM, -- Generated column ID
        'Generated column ID for SRC_OBJ_COL_NM' AS GCID_SRC_OBJ_COL_NM, -- Generated column ID
        'Generated column ID for FIN_DETAIL_AMT' AS GCID_FIN_DETAIL_AMT -- Generated column ID
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_UPDATE
, exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        o_OLD_FT_PRM_AMT1 AS o_OLD_FT_PRM_AMT1,
        o_NEW_FT_PRM_AMT1 AS o_NEW_FT_PRM_AMT1,
        o_TRN_NBCOMM_PRM_AMT1 AS o_TRN_NBCOMM_PRM_AMT1,
        o_TRN_RNCOMM_PRM_AMT1 AS o_TRN_RNCOMM_PRM_AMT1,
        o_TRN_NBCOMM_PRO_AMT1 AS o_TRN_NBCOMM_PRO_AMT1,
        o_TRN_RNCOMM_PRO_AMT1 AS o_TRN_RNCOMM_PRO_AMT1,
        o_FSB_UNPAID_BALANCE1 AS o_FSB_UNPAID_BALANCE1,
        TARGET_TABLE_NAME1 AS TARGET_TABLE_NAME1,
        SOURCE_TABLE_NAME1 AS SOURCE_TABLE_NAME1
    FROM ABC_BAL_ROW_COUNTS
)


-- Source node: nrm_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
, nrm_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK, -- BAL_ROW_COUNTS_SK is normalized into multiple occurrences.
        TRGT_OBJ_TBL_NM,   -- TRGT_OBJ_TBL_NM is normalized into multiple occurrences.
        SRC_OBJ_TBL_NM,    -- SRC_OBJ_TBL_NM is normalized into multiple occurrences.
        TRGT_OBJ_COL_NM,   -- TRGT_OBJ_COL_NM is normalized into multiple occurrences.
        SRC_OBJ_COL_NM,    -- SRC_OBJ_COL_NM is normalized into multiple occurrences.
        FIN_DETAIL_AMT,    -- FIN_DETAIL_AMT is normalized into multiple occurrences.
        'Generated key for normalized occurrences.' AS GK_BAL_ROW_COUNTS_SK, -- Generated key for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_BAL_ROW_COUNTS_SK, -- Generated column ID for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_TRGT_OBJ_TBL_NM, -- Generated column ID for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_SRC_OBJ_TBL_NM, -- Generated column ID for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_TRGT_OBJ_COL_NM, -- Generated column ID for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_SRC_OBJ_COL_NM, -- Generated column ID for normalized occurrences.
        'Generated column ID for normalized occurrences.' AS GCID_FIN_DETAIL_AMT -- Generated column ID for normalized occurrences.
    FROM {{ source('fire_policy', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: agg_UPD_GATE_KPR
, agg_UPD_GATE_KPR AS (
    SELECT 
        PRE_FDR_MAPNG_ID AS PRE_FDR_MAPNG_ID,
        TFPLCY_TRAN_RESULT_SK1 AS TFPLCY_TRAN_RESULT_SK1,
        SRC_SYS_HH_NUM1 AS SRC_SYS_HH_NUM1,
        SRC_TRANS_TMSP1 AS SRC_TRANS_TMSP1,
        LOB_CD1 AS LOB_CD1,
        'Y' AS GATE_KPR_IND, -- Default value for GATE_KPR_IND
        COMPONENT_MODULE_NAME1 AS COMPONENT_MODULE_NAME1,
        CR_BY_MAPNG_ID1 AS CR_BY_MAPNG_ID1,
        DW_CR_TMSP1 AS DW_CR_TMSP1,
        UPD_BY_MAPNG_ID1 AS UPD_BY_MAPNG_ID1,
        DW_UPD_TMSP1 AS DW_UPD_TMSP1,
        WRK_FLOW_RUN_ID1 AS WRK_FLOW_RUN_ID1
    FROM <PREVIOUS_NODE_NAME> -- Replace with actual previous node name
)


-- Source node: int_ABC_MAPPING_AUDIT_INPUT
, int_ABC_MAPPING_AUDIT_INPUT AS (
    SELECT 
        '$PMMappingName' AS MAPPING_NAME, -- Pass mapping name as a constant
        '$PMFolderName' AS FOLDER_NAME,  -- Pass folder name as a constant
        '$PMWorkflowName' AS WORKFLOW_NAME -- Pass workflow name as a constant
)


-- Transformation node: exp_ABC_MAPPING_AUDIT_ID_LOOKUP
, exp_ABC_MAPPING_AUDIT_ID_LOOKUP AS (
    SELECT 
        'm_FDR_FIRE_PLCY_TRANS_RSLT_PL' AS MAPPING_NAME,
        'FOLDER_NAME_PLACEHOLDER' AS FOLDER_NAME, -- Replace with actual folder name if available
        'WORKFLOW_NAME_PLACEHOLDER' AS WORKFLOW_NAME, -- Replace with actual workflow name if available
        v_RECORD_NUM + 1 AS v_RECORD_NUM,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN :LKP.lkp_MAP_ID('m_FDR_FIRE_PLCY_TRANS_RSLT_PL', 'FOLDER_NAME_PLACEHOLDER')
            ELSE v_MAPNG_ID
        END AS v_MAPNG_ID,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN 
                CASE 
                    WHEN ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC('WORKFLOW_NAME_PLACEHOLDER')) THEN :LKP.lkp_WORKFLOW_RUN_ID('WORKFLOW_NAME_PLACEHOLDER')
                    ELSE :LKP.LKP_WORKFLOW_RUN_ID_ABC('WORKFLOW_NAME_PLACEHOLDER')
                END
            ELSE v_WRK_FLOW_RUN_ID
        END AS v_WRK_FLOW_RUN_ID,
        v_MAPNG_ID AS CR_BY_MAPNG_ID,
        SESSSTARTTIME AS DW_CR_TMSP,
        v_MAPNG_ID AS UPD_BY_MAPNG_ID,
        SESSSTARTTIME AS DW_UPD_TMSP,
        v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
    FROM previous_node_placeholder -- Replace with actual previous node name if available
)


-- Source node: out_ABC_MAPPING_AUDIT_OUTPUT
, out_ABC_MAPPING_AUDIT_OUTPUT AS (
    SELECT 
        'CR_BY_MAPNG_ID' AS CR_BY_MAPNG_ID, -- Derived constant field
        'DW_CR_TMSP' AS DW_CR_TMSP,         -- Derived constant field
        'UPD_BY_MAPNG_ID' AS UPD_BY_MAPNG_ID, -- Derived constant field
        'DW_UPD_TMSP' AS DW_UPD_TMSP,       -- Derived constant field
        'WRK_FLOW_RUN_ID' AS WRK_FLOW_RUN_ID -- Derived constant field
)


-- Transformation node: exp_DERIVE_FACESHEET_DT
, exp_DERIVE_FACESHEET_DT AS (
    SELECT 
        PLCY_ID_SK_APD_DT,
        FACESHEET_PRNT_DT_APD_DT,
        PLCY_ID_SK_LAT_DT,
        FACESHEET_PRNT_DT_LAT_DT,
        SRC_FACESHEET_PRINT_DT,
        SRC_DUP_FLAG,
        SRC_LAT_DATE_LAT_TIME,
        SRC_APPLIED_DTSTMP,
        -- Derived fields
        CASE 
            WHEN SRC_FACESHEET_PRINT_DT IS NULL THEN TO_DATE('01/01/1800', 'MM/DD/YYYY') 
            ELSE SRC_FACESHEET_PRINT_DT 
        END AS v_SRC_FACESHEET_PRINT_DT,
        CASE 
            WHEN PLCY_ID_SK_APD_DT IS NOT NULL THEN 
                CASE 
                    WHEN FACESHEET_PRNT_DT_APD_DT IS NULL THEN TO_DATE('01/01/1800', 'MM/DD/YYYY') 
                    ELSE FACESHEET_PRNT_DT_APD_DT 
                END
            WHEN PLCY_ID_SK_LAT_DT IS NOT NULL THEN 
                CASE 
                    WHEN FACESHEET_PRNT_DT_LAT_DT IS NULL THEN TO_DATE('01/01/1800', 'MM/DD/YYYY') 
                    ELSE FACESHEET_PRNT_DT_LAT_DT 
                END
        END AS v_FINAL_FACESHEET_PRINT_DT,
        CASE 
            WHEN v_FINAL_FACESHEET_PRINT_DT <> v_SRC_FACESHEET_PRINT_DT THEN v_SRC_FACESHEET_PRINT_DT 
        END AS v_DERIVED_FACESHEET_PRINT_DT,
        v_DERIVED_FACESHEET_PRINT_DT AS o_DERIVED_FACESHEET_PRINT_DT,
        CASE 
            WHEN SRC_DUP_FLAG = 0 AND (PLCY_ID_SK_APD_DT IS NOT NULL OR PLCY_ID_SK_LAT_DT IS NOT NULL) THEN 1 
            ELSE 0 
        END AS v_UPD_FLAG,
        v_UPD_FLAG AS o_UPD_FLAG,
        SRC_PLCY_ID_SK,
        CASE 
            WHEN PLCY_ID_SK_APD_DT IS NOT NULL THEN SRC_APPLIED_DTSTMP 
            WHEN PLCY_ID_SK_LAT_DT IS NOT NULL THEN SRC_LAT_DATE_LAT_TIME 
        END AS v_SRC_INSERT_TRANS_TMSP,
        v_SRC_INSERT_TRANS_TMSP AS SRC_INSERT_TRANS_TMSP,
        SRC_EFF_DT,
        CR_BY_MAPNG_ID,
        DW_CR_TMSP,
        UPD_BY_MAPNG_ID,
        DW_UPD_TMSP,
        WRK_FLOW_RUN_ID
    FROM <PREVIOUS_NODE_NAME>
)


-- Transformation node: exp_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
, exp_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        'OLD_FULL_TERM_PREM_AMT' AS TRGT_OLD_FULL_TERM_PREM_AMT,
        'NEW_FULL_TERM_PREM_AMT' AS TRGT_NEW_FULL_TERM_PREM_AMT,
        'TRANS_NEW_BUS_COMM_PREM_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PREM_AMT,
        'TRANS_RNCOMM_PREM_AMT' AS TRGT_TRANS_RNCOMM_PREM_AMT,
        'TRANS_NEW_BUS_COMM_PRO_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PRO_AMT,
        'TRANS_RNCOMM_PRO_AMT' AS TRGT_TRANS_RNCOMM_PRO_AMT,
        'FSB_UNPD_BAL' AS TRGT_FSB_UNPD_BAL
    FROM <PREVIOUS_NODE_NAME>
)


-- Transformation node: exp_NORM_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
, exp_NORM_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK,
        TRGT_TBL_NM,
        SRC_TBL_NM,
        TRGT_COL_NM,
        SRC_COL_NM,
        -- Lookup logic for WRKFL_CMPNT_OBJ_ID
        COALESCE(
            (
                SELECT WRKFL_CMPNT_OBJ_ID
                FROM LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID
                WHERE TRGT_TBL_NM = LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID.TRGT_TBL_NM
                  AND SRC_TBL_NM = LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID.SRC_TBL_NM
                  AND TRGT_COL_NM = LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID.TRGT_COL_NM
                  AND SRC_COL_NM = LKP_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_COL_OBJ_ID.SRC_COL_NM
            ),
            NULL
        ) AS WRKFL_CMPNT_OBJ_ID,
        FIN_DETAIL_AMT
    FROM <PREVIOUS_NODE_NAME>
)


-- Source node: exp_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
, exp_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK, -- Primary key for balance row counts
        TRGT_TBL_NM,       -- Target table name
        SRC_TBL_NM,        -- Source table name
        'OLD_FULL_TERM_PREM_AMT' AS TRGT_OLD_FULL_TERM_PREM_AMT, -- Old full-term premium amount
        'NEW_FULL_TERM_PREM_AMT' AS TRGT_NEW_FULL_TERM_PREM_AMT, -- New full-term premium amount
        'TRANS_NEW_BUS_COMM_PREM_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PREM_AMT, -- Transaction new business commission premium amount
        'TRANS_RNCOMM_PREM_AMT' AS TRGT_TRANS_RNCOMM_PREM_AMT, -- Transaction renewal commission premium amount
        'TRANS_NEW_BUS_COMM_PRO_AMT' AS TRGT_TRANS_NEW_BUS_COMM_PRO_AMT, -- Transaction new business commission pro amount
        'TRANS_RNCOMM_PRO_AMT' AS TRGT_TRANS_RNCOMM_PRO_AMT, -- Transaction renewal commission pro amount
        'FSB_UNPD_BAL' AS TRGT_FSB_UNPD_BAL -- FSB unpaid balance
    FROM {{ source('FIRE_POLICY', 'ABC_BAL_ROW_COUNTS') }}
)


-- Transformation node: nrm_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
, nrm_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
    SELECT 
        BAL_ROW_COUNTS_SK AS BAL_ROW_COUNTS_SK,
        TRGT_OBJ_TBL_NM AS TRGT_OBJ_TBL_NM,
        SRC_OBJ_TBL_NM AS SRC_OBJ_TBL_NM,
        TRGT_OBJ_COL_NM AS TRGT_OBJ_COL_NM,
        SRC_OBJ_COL_NM AS SRC_OBJ_COL_NM,
        FIN_DETAIL_AMT AS FIN_DETAIL_AMT,
        1 AS GK_BAL_ROW_COUNTS_SK, -- Generated key for BAL_ROW_COUNTS_SK with sequence generator value 1
        CONCAT('GCID_', BAL_ROW_COUNTS_SK) AS GCID_BAL_ROW_COUNTS_SK, -- Generated column ID for BAL_ROW_COUNTS_SK
        CONCAT('GCID_', TRGT_OBJ_TBL_NM) AS GCID_TRGT_OBJ_TBL_NM, -- Generated column ID for TRGT_OBJ_TBL_NM
        CONCAT('GCID_', SRC_OBJ_TBL_NM) AS GCID_SRC_OBJ_TBL_NM, -- Generated column ID for SRC_OBJ_TBL_NM
        CONCAT('GCID_', TRGT_OBJ_COL_NM) AS GCID_TRGT_OBJ_COL_NM, -- Generated column ID for TRGT_OBJ_COL_NM
        CONCAT('GCID_', SRC_OBJ_COL_NM) AS GCID_SRC_OBJ_COL_NM, -- Generated column ID for SRC_OBJ_COL_NM
        CONCAT('GCID_', FIN_DETAIL_AMT) AS GCID_FIN_DETAIL_AMT -- Generated column ID for FIN_DETAIL_AMT
    FROM <PREVIOUS_NODE_NAME> -- Replace <PREVIOUS_NODE_NAME> with the actual previous node name
)


{{ config(
    materialized='incremental',
    alias='ABC_BAL_DETAIL_AMTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BAL_ROW_COUNTS_SK', 'WRKFL_CMPNT_OBJ_ID', 'FIN_DETAIL_AMT']
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'PROC_CD',
        'o_RECRD_CNT_QTY',
        'TFPLCY_TRAN_RESULT_SK1',
        'LAT_DATE1',
        'LAT_TIME1',
        'LAT_ACTION1',
        'STG_CR_BY_MAPNG_ID1',
        'STG_DW_CR_TMSP1',
        'STG_UPD_BY_MAPNG_ID1'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_SOURCE_INSERT
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_DETAIL_AMTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BAL_ROW_COUNTS_SK', 'WRKFL_CMPNT_OBJ_ID', 'FIN_DETAIL_AMT']
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_DETAIL_AMTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BAL_ROW_COUNTS_SK', 'WRKFL_CMPNT_OBJ_ID', 'FIN_DETAIL_AMT']
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_DETAIL_AMTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BAL_ROW_COUNTS_SK', 'WRKFL_CMPNT_OBJ_ID', 'FIN_DETAIL_AMT']
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_DETAIL_AMTS_RP_INSERT
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='PRE_FDR_FIRE_PLCY_TRANS_RSLT',
    unique_key='TFPLCY_TRAN_RESULT_SK1',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'TFPLCY_TRAN_RESULT_SK1',
        'LAT_DATE1',
        'LAT_TIME1',
        'LAT_ACTION1',
        'STG_CR_BY_MAPNG_ID1',
        'STG_DW_CR_TMSP1',
        'STG_UPD_BY_MAPNG_ID1',
        'STG_DW_UPD_TMSP1',
        'STG_WRK_FLOW_RUN_ID1',
        'POLICY_NUMBER1'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_INSERT
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='FDR_FIRE_PLCY_TRANS_RSLT',
    unique_key='SRC_PLCY_ID_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'SRC_PLCY_ID_SK',
        'SRC_INSERT_TRANS_TMSP',
        'SRC_EFF_DT',
        'o_DERIVED_FACESHEET_PRINT_DT',
        'CR_BY_MAPNG_ID',
        'DW_CR_TMSP',
        'UPD_BY_MAPNG_ID',
        'DW_UPD_TMSP',
        'WRK_FLOW_RUN_ID'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_FACESHEET_DT
)

SELECT * FROM final


-- Transformation node: out_ABC_ERROR_MAPPLET_OUTPUT
, out_ABC_ERROR_MAPPLET_OUTPUT AS (
    SELECT 
        'DD_INSERT' AS ERR_DESC,
        'DD_INSERT' AS WRKFL_MAPNG_ID,
        'DD_INSERT' AS ERR_RESOLUTION_TMSP,
        'DD_INSERT' AS WRKFL_RUN_ID,
        'DD_INSERT' AS WRKFL_CMPNT_ID,
        'DD_INSERT' AS STD_MSG_ID,
        'DD_INSERT' AS ERR_STAT,
        'DD_INSERT' AS WRKFL_NM,
        'DD_INSERT' AS WRKFL_CMPNT_NM,
        'DD_INSERT' AS MSG_TMSP,
        'DD_INSERT' AS CMPNT_MODULE_NM,
        'DD_INSERT' AS CMPNT_MODULE_PK
    FROM upd_INSERT_ERROR_RECORD
)


{{ config(
    materialized='incremental',
    alias='ABC_BAL_DETAIL_AMTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BAL_ROW_COUNTS_SK', 'WRKFL_CMPNT_OBJ_ID', 'FIN_DETAIL_AMT']
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_GATE_KPR',
    unique_key='TFPLCY_TRAN_RESULT_SK6',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'TFPLCY_TRAN_RESULT_SK6',
        'SRC_SYS_HH_NUM6',
        'SRC_TRANS_TMSP6',
        'COMPONENT_MODULE_NAME6',
        'LOB_CD6',
        'GATE_KPR_IND',
        'CR_BY_MAPNG_ID6',
        'DW_CR_TMSP6',
        'UPD_BY_MAPNG_ID6',
        'DW_UPD_TMSP6',
        'WRK_FLOW_RUN_ID6'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_INS_GATE_KPR
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'REPROC_TYP_CD',
        'WORKFLOW_NAME4',
        'WORKFLOW_COMPONENT_NAME4',
        'WRK_FLOW_RUN_ID4',
        'RECRD_CNT_TYP_ACTN_CD',
        'RECRD_CNT_TYP_CD',
        'REPROC_TARGET_TABLE_NAME',
        'o_RECRD_CNT_QTY',
        'SOURCE_TABLE_NAME4',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_ROW_COUNTS3
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'PROC_CD',
        'PRE_FDR_MAPNG_ID',
        'WORKFLOW_NAME1',
        'WORKFLOW_COMPONENT_NAME1',
        'TARGET_TABLE_NAME1',
        'SOURCE_TABLE_NAME1',
        'WRK_FLOW_RUN_ID1',
        'RECRD_CNT_TYP_ACTN_INS1',
        'RECRD_CNT_TYP_CD_RP_INS',
        'o_RECRD_CNT_QTY',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_ROW_COUNTS2
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_GATE_KPR',
    unique_key='TFPLCY_TRAN_RESULT_SK1',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'PRE_FDR_MAPNG_ID',
        'TFPLCY_TRAN_RESULT_SK1',
        'SRC_SYS_HH_NUM1',
        'SRC_TRANS_TMSP1',
        'LOB_CD1',
        'GATE_KPR_IND',
        'COMPONENT_MODULE_NAME1',
        'CR_BY_MAPNG_ID1',
        'DW_CR_TMSP1',
        'UPD_BY_MAPNG_ID1',
        'DW_UPD_TMSP1',
        'WRK_FLOW_RUN_ID1'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_UPD_GATE_KPR
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'PROC_CD3',
        'o_RECRD_CNT_QTY',
        'RECRD_CNT_TYP_CD_INS3',
        'RECRD_CNT_TYP_ACTN_INS3',
        'WORKFLOW_NAME3',
        'TARGET_TABLE_NAME3',
        'SOURCE_TABLE_NAME3',
        'WRK_FLOW_RUN_ID3',
        'WORKFLOW_COMPONENT_NAME3',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_ABC_BAL_ROW_COUNTS_SOURCE_INSERT_UPDATE
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='ABC_BAL_ROW_COUNTS',
    unique_key='BAL_ROW_COUNTS_SK',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'BAL_ROW_COUNTS_SK',
        'TRGT_TBL_NM',
        'SRC_TBL_NM',
        'WRKFL_CMPNT_NM',
        'RECRD_CNT_TYP_CD',
        'RECRD_CNT_ACTN_CD',
        'RECRD_CNT_QTY',
        'WRKFL_RUN_ID',
        'WRKFL_NM',
        'TRGT_TBL_WRKFL_CMPNT_OBJ_ID',
        'SRC_TBL_WRKFL_CMPNT_OBJ_ID'
    ]
) }}

final AS (
    SELECT
        *
    FROM upd_INSERT_ABC
)

SELECT * FROM final