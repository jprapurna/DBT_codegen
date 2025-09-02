{{ config(materialized='view') }}

WITH fact_ag_written_prem_cvg_lvl AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_premium_sk, -- On/off premium SK
        "REGSTR_PER_SK" AS registration_period_sk, -- Registration period SK
        "SRC_TRANS_TMSP" AS source_transaction_timestamp, -- Source transaction timestamp
        "TRANS_DT_SK" AS transaction_date_sk, -- Transaction date SK
        "DNSTRM_DT_SK" AS downstream_date_sk, -- Downstream date SK
        "EFF_DT_SK" AS effective_date_sk, -- Effective date SK
        "TERM_STRT_DT_SK" AS term_start_date_sk, -- Term start date SK
        "FISC_PER_SK" AS fiscal_period_sk, -- Fiscal period SK
        "ADJ_PER_SK" AS adjustment_period_sk, -- Adjustment period SK
        "PLCY_PER_SK" AS policy_period_sk, -- Policy period SK
        "TRANS_TYP_SK" AS transaction_type_sk, -- Transaction type SK
        "TRANS_TYP_PLCY_SK" AS transaction_type_policy_sk, -- Transaction type policy SK
        "MINI_HH_SK" AS mini_household_sk, -- Mini household SK
        "MINI_PLCY_SK" AS mini_policy_sk, -- Mini policy SK
        "MINI_SOI_SK" AS mini_soi_sk, -- Mini SOI SK
        "MINI_CVG_SK" AS mini_coverage_sk, -- Mini coverage SK
        "MINI_AGT_SK" AS mini_agent_sk, -- Mini agent SK
        "MINI_RDRVR_SK" AS mini_rated_driver_sk, -- Mini rated driver SK
        "HH_SK" AS household_sk, -- Household SK
        "PLCY_SK" AS policy_sk, -- Policy SK
        "SOI_SK" AS soi_sk, -- SOI SK
        "CVG_SK" AS coverage_sk, -- Coverage SK
        "PNI_SK" AS policyholder_sk, -- Policyholder SK
        "AGT_SK" AS agent_sk, -- Agent SK
        "RDRVR_SK" AS rated_driver_sk, -- Rated driver SK
        "FARMR_GEO_DISTR_SK" AS farmer_geographic_distribution_sk, -- Farmer geographic distribution SK
        "RATED_GEO_SK" AS rated_geographic_sk, -- Rated geographic SK
        "DNSTRM_REGSTR_PER_SK" AS downstream_registration_period_sk, -- Downstream registration period SK
        "DNSTRM_FISC_PER_SK" AS downstream_fiscal_period_sk, -- Downstream fiscal period SK
        "MINI_PNI_SK" AS mini_policyholder_sk, -- Mini policyholder SK
        "DC_VER_IND_CVG" AS dc_verification_indicator_coverage, -- DC verification indicator coverage
        "DC_VER_IND_SOI" AS dc_verification_indicator_soi, -- DC verification indicator SOI
        "DC_VER_IND_PLCY" AS dc_verification_indicator_policy, -- DC verification indicator policy
        "ON_OFF_PREM_TYP_RECRD" AS on_off_premium_type_record, -- On/off premium type record
        "PLCY_KOR_CD" AS policy_kor_code, -- Policy KOR code
        "UNIT_KOR_CD" AS unit_kor_code, -- Unit KOR code
        "WRITTN_PREM_AMT" AS written_premium_amount, -- Written premium amount
        "TTL_WRITTN_PREM_AMT" AS total_written_premium_amount, -- Total written premium amount
        "UNCAP_WRITTN_PREM_AMT" AS uncapped_written_premium_amount, -- Uncapped written premium amount
        "ALLOC_TDC_AMT" AS allocated_tdc_amount, -- Allocated TDC amount
        "ALLOC_MANL_ADJ_AMT" AS allocated_manual_adjustment_amount, -- Allocated manual adjustment amount
        "ALLOC_ASGN_RSK_INSTL_FEE_AMT" AS allocated_assigned_risk_installation_fee_amount, -- Allocated assigned risk installation fee amount
        "ALLOC_EP_WRIT_OFF_AMT" AS allocated_ep_write_off_amount, -- Allocated EP write-off amount
        "CVG_EXPS_VAL" AS coverage_expense_value, -- Coverage expense value
        "PLCY_FEE_AMT" AS policy_fee_amount, -- Policy fee amount
        "DRVR_FILNG_FEE_AMT" AS driver_filing_fee_amount, -- Driver filing fee amount
        "REINST_FEE_AMT" AS reinstatement_fee_amount, -- Reinstatement fee amount
        "PREM_CAP_FCTR" AS premium_cap_factor, -- Premium cap factor
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id, -- Workflow run ID
        "FULL_TERM_PREM_AMT" AS full_term_premium_amount, -- Full term premium amount
        "PLCY_ENH_SK" AS policy_enhancement_sk, -- Policy enhancement SK
        "SOI_ENH_SK" AS soi_enhancement_sk, -- SOI enhancement SK
        "REGSTR_CUST_SGMTN_SK" AS registration_customer_segmentation_sk, -- Registration customer segmentation SK
        "TERM_CUST_SGMTN_SK" AS term_customer_segmentation_sk, -- Term customer segmentation SK
        "REGSTR_CUST_SGMTN_V2_SK" AS registration_customer_segmentation_v2_sk, -- Registration customer segmentation V2 SK
        "TERM_CUST_SGMTN_V2_SK" AS term_customer_segmentation_v2_sk, -- Term customer segmentation V2 SK
        "FL_HURR_CAT_FUND_AMT" AS florida_hurricane_catastrophe_fund_amount, -- Florida hurricane catastrophe fund amount
        "FL_CPIC_REG_ASSMNT_AMT" AS florida_cpic_regular_assessment_amount, -- Florida CPIC regular assessment amount
        "FL_CPIC_EMERG_SURCHRG_AMT" AS florida_cpic_emergency_surcharge_amount, -- Florida CPIC emergency surcharge amount
        "FL_IGA_REG_AMT" AS florida_iga_regular_amount, -- Florida IGA regular amount
        "FL_IGA_EMERG_AMT" AS florida_iga_emergency_amount -- Florida IGA emergency amount
    FROM {{ source('GENAI_POWER_BI', 'FACT_AG_WRITTN_PREM_CVG_LVL') }}
)
SELECT
    on_off_premium_sk,
    registration_period_sk,
    source_transaction_timestamp,
    transaction_date_sk,
    downstream_date_sk,
    effective_date_sk,
    term_start_date_sk,
    fiscal_period_sk,
    adjustment_period_sk,
    policy_period_sk,
    transaction_type_sk,
    transaction_type_policy_sk,
    mini_household_sk,
    mini_policy_sk,
    mini_soi_sk,
    mini_coverage_sk,
    mini_agent_sk,
    mini_rated_driver_sk,
    household_sk,
    policy_sk,
    soi_sk,
    coverage_sk,
    policyholder_sk,
    agent_sk,
    rated_driver_sk,
    farmer_geographic_distribution_sk,
    rated_geographic_sk,
    downstream_registration_period_sk,
    downstream_fiscal_period_sk,
    mini_policyholder_sk,
    dc_verification_indicator_coverage,
    dc_verification_indicator_soi,
    dc_verification_indicator_policy,
    on_off_premium_type_record,
    policy_kor_code,
    unit_kor_code,
    written_premium_amount,
    total_written_premium_amount,
    uncapped_written_premium_amount,
    allocated_tdc_amount,
    allocated_manual_adjustment_amount,
    allocated_assigned_risk_installation_fee_amount,
    allocated_ep_write_off_amount,
    coverage_expense_value,
    policy_fee_amount,
    driver_filing_fee_amount,
    reinstatement_fee_amount,
    premium_cap_factor,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id,
    full_term_premium_amount,
    policy_enhancement_sk,
    soi_enhancement_sk,
    registration_customer_segmentation_sk,
    term_customer_segmentation_sk,
    registration_customer_segmentation_v2_sk,
    term_customer_segmentation_v2_sk,
    florida_hurricane_catastrophe_fund_amount,
    florida_cpic_regular_assessment_amount,
    florida_cpic_emergency_surcharge_amount,
    florida_iga_regular_amount,
    florida_iga_emergency_amount
FROM fact_ag_written_prem_cvg_lvl