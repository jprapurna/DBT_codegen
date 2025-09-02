{{ config(materialized='view') }}

WITH dim_ag_soi AS (
    SELECT
        "SOI_SK" AS soi_sk, -- Primary key for SOI
        "CHK_SUM_ATTR" AS checksum_attribute, -- Checksum attribute
        "SOI_ID" AS soi_id, -- SOI ID
        "VIN" AS vehicle_identification_number, -- Vehicle identification number
        "VEH_INCEPT_DT" AS vehicle_inception_date, -- Vehicle inception date
        "UNIT_NUM" AS unit_number, -- Unit number
        "VEH_MK_NM" AS vehicle_make_name, -- Vehicle make name
        "VEH_MDL_NM" AS vehicle_model_name, -- Vehicle model name
        "VEH_MDL_YR" AS vehicle_model_year, -- Vehicle model year
        "SOI_TYP" AS soi_type, -- SOI type
        "SOI_TYP_DESC" AS soi_type_description, -- SOI type description
        "ANN_MIL" AS annual_mileage, -- Annual mileage
        "MCA_PNT_CNT" AS mca_point_count, -- MCA point count
        "CAR_SYM" AS car_symbol, -- Car symbol
        "LIAB_BI_SYM" AS liability_bi_symbol, -- Liability BI symbol
        "LIAB_BI_SYM_RNGE" AS liability_bi_symbol_range, -- Liability BI symbol range
        "LIAB_PD_SYM" AS liability_pd_symbol, -- Liability PD symbol
        "LIAB_PD_SYM_RNGE" AS liability_pd_symbol_range, -- Liability PD symbol range
        "MED_PIP_SYM" AS medical_pip_symbol, -- Medical PIP symbol
        "MED_PIP_SYM_RNGE" AS medical_pip_symbol_range, -- Medical PIP symbol range
        "COLL_SYM_RNGE" AS collision_symbol_range, -- Collision symbol range
        "COLL_SYM" AS collision_symbol, -- Collision symbol
        "COMPRE_SYM" AS comprehensive_symbol, -- Comprehensive symbol
        "COMPRE_SYM_RNGE" AS comprehensive_symbol_range, -- Comprehensive symbol range
        "CNCL_FORM_CD" AS cancellation_form_code, -- Cancellation form code
        "CNCL_FORM_DESC" AS cancellation_form_description, -- Cancellation form description
        "RDRVR_AGE" AS rated_driver_age, -- Rated driver age
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
        "MINI_SOI_SK" AS mini_soi_sk, -- Mini SOI SK
        "MINI_SOI_CHK_SUM" AS mini_soi_checksum, -- Mini SOI checksum
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_SOI') }}
)
SELECT
    soi_sk,
    checksum_attribute,
    soi_id,
    vehicle_identification_number,
    vehicle_inception_date,
    unit_number,
    vehicle_make_name,
    vehicle_model_name,
    vehicle_model_year,
    soi_type,
    soi_type_description,
    annual_mileage,
    mca_point_count,
    car_symbol,
    liability_bi_symbol,
    liability_bi_symbol_range,
    liability_pd_symbol,
    liability_pd_symbol_range,
    medical_pip_symbol,
    medical_pip_symbol_range,
    collision_symbol_range,
    collision_symbol,
    comprehensive_symbol,
    comprehensive_symbol_range,
    cancellation_form_code,
    cancellation_form_description,
    rated_driver_age,
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
    mini_soi_sk,
    mini_soi_checksum,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id
FROM dim_ag_soi