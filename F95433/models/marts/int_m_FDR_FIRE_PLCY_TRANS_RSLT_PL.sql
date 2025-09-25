{{
  config(
    materialized='ephemeral'
  )
}}

WITH source_data AS (
  SELECT * FROM {{ source('genai_power_bi', 'STG_TFPLCY_TRAN_RESULT') }}
),

dedup_data AS (
  SELECT
    TFPLCY_TRAN_RESULT_SK,
    LAT_DATE,
    LAT_TIME,
    LAT_ACTION,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID,
    REPROC_CNT,
    POLICY_NUMBER,
    APPLIED_DTSTMP,
    OLD_FT_PRM_AMT,
    NEW_FT_PRM_AMT,
    TRN_NBCOMM_PRM_AMT,
    TRN_RNCOMM_PRM_AMT,
    TRN_NBCOMM_PRO_AMT,
    TRN_RNCOMM_PRO_AMT,
    FSB_UNPAID_BALANCE,
    ACS_NBCOMM_PRM_AMT,
    POLICY_FEE_CD,
    POLICY_FEE_AMT,
    REINST_FEE_AMT,
    STATE_CHRG_AMT,
    TRN_POLICY_FEE_AMT,
    TRN_REINST_FEE_AMT,
    ACS_POLICY_FEE_AMT,
    ACS_REINST_FEE_AMT,
    TRN_STATE_CHRG_AMT,
    SALES_COUNT_TOT_PD,
    TRN_SALES_COUNT_PD,
    EFF_DT,
    EXP_DT,
    ACS_RNCOMM_PRM_AMT,
    FACESHEET_PRINT_DT,
    TRN_OPERATING_COST,
    ACS_NB_COMM_AMT,
    ACS_RN_COMM_AMT,
    ACS_NB_CITY_TX_AMT,
    ACS_NB_CNTY_TX_AMT,
    ACS_NB_SURCHG_AMT,
    ACS_NB_CLCTN_FEE,
    ACS_RN_CITY_TX_AMT,
    ACS_RN_CNTY_TX_AMT,
    ACS_RN_SURCHG_AMT,
    ACS_RN_CLCTN_FEE,
    TRN_BILLED_TAX_AMT,
    TRN_SURCHARGE_AMT,
    TRN_COLLECTION_FEE,
    TRN_PRORATE_FACTOR,
    ROLLUP_POLICY_FEE,
    ROLLUP_REINST_FEE,
    PRE_FDR_MAPNG_ID,
    MISC_AMT,
    RVRSL_OLD_FT_PRM,
    RVRSL_NEW_FT_PRM,
    OFF_PRM_AMT,
    ON_PRM_AMT,
    RVRSL_OFF_PRM_AMT,
    RVRSL_ON_PRM_AMT,
    CAP_TERM_NUM,
    RTG_CAP_CD,
    RTG_CAP_FCTR,
    HOUSEHOLD_NUM,
    ALT_PRORATE_FCTR,
    HAZARD_DIS_PCT
  FROM source_data
  WHERE PRE_FDR_MAPNG_ID = 0
),

error_logging AS (
  SELECT
    *,
    {{ mplt_FDR_LIB_LOG_ABC_ERROR_MESSAGES(
      err_desc='Error description',
      wrkfl_mapng_id='Workflow Mapping ID',
      err_resolution_tmsp='Error Resolution Timestamp',
      wrkfl_run_id='Workflow Run ID',
      wrkfl_cmpnt_id='Workflow Component ID',
      std_msg_id='Standard Message ID',
      err_stat='Error Status',
      wrkfl_nm='Workflow Name',
      msg_id='Message ID',
      wrkfl_cmpnt_nm='Workflow Component Name',
      msg_tmsp='Message Timestamp',
      cmpnt_module_nm='Component Module Name',
      cmpnt_module_pk='Component Module Primary Key'
    ) }}
  FROM dedup_data
)

SELECT * FROM error_logging