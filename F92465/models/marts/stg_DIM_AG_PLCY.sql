{{ config(materialized='view') }}

WITH dim_ag_plcy AS (
    SELECT
        "PLCY_SK" AS policy_sk, -- Primary key for policy
        "CHK_SUM_ATTR" AS checksum_attribute, -- Checksum attribute
        "PLCY_ID_SK" AS policy_id_sk, -- Policy ID SK
        "PLCY_CNTRCT_NUM" AS policy_contract_number, -- Policy contract number
        "PLCY_INCEPT_DT" AS policy_inception_date, -- Policy inception date
        "PERSTNCY_YRS" AS persistency_years, -- Persistency years
        "LPS_DAYS_CNT" AS lapse_days_count, -- Lapse days count
        "TERM_STRT_DT" AS term_start_date, -- Term start date
        "TERM_END_DT" AS term_end_date, -- Term end date
        "PNI_AGE" AS policyholder_age, -- Policyholder age
        "XCLUDED_DRVR_CHLD_IND" AS excluded_driver_child_indicator, -- Excluded driver child indicator
        "XCLUDED_DRVR_OTH_IND" AS excluded_driver_other_indicator, -- Excluded driver other indicator
        "XCLUDED_DRVR_PARENT_IND" AS excluded_driver_parent_indicator, -- Excluded driver parent indicator
        "XCLUDED_DRVR_SPS_IND" AS excluded_driver_spouse_indicator, -- Excluded driver spouse indicator
        "LIFE_PLCY_IND" AS life_policy_indicator, -- Life policy indicator
        "ADVNC_PURCH_IND" AS advance_purchase_indicator, -- Advance purchase indicator
        "ALTR_VEH_IND" AS alternative_vehicle_indicator, -- Alternative vehicle indicator
        "ALTRN_FUEL_IND" AS alternative_fuel_indicator, -- Alternative fuel indicator
        "ABS_IND" AS abs_indicator, -- ABS indicator
        "ANTI_THFT_IND" AS anti_theft_indicator, -- Anti-theft indicator
        "ANTIQ_CAR_IND" AS antique_car_indicator, -- Antique car indicator
        "DRVR_TRNG_IND" AS driver_training_indicator, -- Driver training indicator
        "ELECTRNC_STABLTY_CTRL_DISC_IND" AS electronic_stability_control_discount_indicator, -- Electronic stability control discount indicator
        "HI_PERF_IND" AS high_performance_indicator, -- High performance indicator
        "NEW_PARENT_IND" AS new_parent_indicator, -- New parent indicator
        "PASSV_RESTRA_IND" AS passive_restraint_indicator, -- Passive restraint indicator
        "PRI_INS_DISC_IND" AS primary_insurance_discount_indicator, -- Primary insurance discount indicator
        "CONVICT_FREE_IND" AS conviction_free_indicator, -- Conviction-free indicator
        "SR22_FILNG_IND" AS sr22_filing_indicator, -- SR22 filing indicator
        "DEFNS_DRVR_DISC_IND" AS defensive_driver_discount_indicator, -- Defensive driver discount indicator
        "TEEN_DRVR_IND" AS teen_driver_indicator, -- Teen driver indicator
        "SNR_DRVR_IND" AS senior_driver_indicator, -- Senior driver indicator
        "UNVERFYBL_DRVNG_RECRD_IND" AS unverifiable_driving_record_indicator, -- Unverifiable driving record indicator
        "MINI_PLCY_SK" AS mini_policy_sk, -- Mini policy SK
        "MINI_PLCY_CHK_SUM" AS mini_policy_checksum, -- Mini policy checksum
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_PLCY') }}
)
SELECT
    policy_sk,
    checksum_attribute,
    policy_id_sk,
    policy_contract_number,
    policy_inception_date,
    persistency_years,
    lapse_days_count,
    term_start_date,
    term_end_date,
    policyholder_age,
    excluded_driver_child_indicator,
    excluded_driver_other_indicator,
    excluded_driver_parent_indicator,
    excluded_driver_spouse_indicator,
    life_policy_indicator,
    advance_purchase_indicator,
    alternative_vehicle_indicator,
    alternative_fuel_indicator,
    abs_indicator,
    anti_theft_indicator,
    antique_car_indicator,
    driver_training_indicator,
    electronic_stability_control_discount_indicator,
    high_performance_indicator,
    new_parent_indicator,
    passive_restraint_indicator,
    primary_insurance_discount_indicator,
    conviction_free_indicator,
    sr22_filing_indicator,
    defensive_driver_discount_indicator,
    teen_driver_indicator,
    senior_driver_indicator,
    unverifiable_driving_record_indicator,
    mini_policy_sk,
    mini_policy_checksum,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id
FROM dim_ag_plcy