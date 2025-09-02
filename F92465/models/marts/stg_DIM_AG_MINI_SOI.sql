{{ config(materialized='view') }}

WITH dim_ag_mini_soi AS (
    SELECT
        "MINI_SOI_SK" AS mini_soi_sk, -- Primary key for mini SOI
        "CHK_SUM_ATTR" AS checksum_attribute, -- Checksum attribute
        "VEH_TYP_CD" AS vehicle_type_code, -- Vehicle type code
        "VEH_TYP_DESC" AS vehicle_type_description, -- Vehicle type description
        "SOI_CTGY" AS soi_category, -- SOI category
        "VEH_USE_CD" AS vehicle_use_code, -- Vehicle use code
        "MCA_PNT_CNT_RNGE" AS mca_point_count_range, -- MCA point count range
        "ANN_MIL_RNGE" AS annual_mileage_range, -- Annual mileage range
        "CAR_SYM_RNGE" AS car_symbol_range, -- Car symbol range
        "RDRVR_AGE_RNGE" AS rated_driver_age_range, -- Rated driver age range
        "RATE_CLS_CD" AS rate_class_code, -- Rate class code
        "OCCUPTN_CD" AS occupation_code, -- Occupation code
        "OCCUPTN_DESC" AS occupation_description, -- Occupation description
        "OCCUPTN_CD_PRGM" AS occupation_code_program, -- Occupation code program
        "COLL_DED" AS collision_deductible, -- Collision deductible
        "CA_PNTD_IND" AS california_painted_indicator, -- California painted indicator
        "GRP_DISC_IND" AS group_discount_indicator, -- Group discount indicator
        "NEW_CAR_CRED_IND" AS new_car_credit_indicator, -- New car credit indicator
        "RETRMNT_CMNTY_DISC_IND" AS retirement_community_discount_indicator, -- Retirement community discount indicator
        "VEH_USE_SURCHRG_IND" AS vehicle_use_surcharge_indicator, -- Vehicle use surcharge indicator
        "LXRY_VEH_IND" AS luxury_vehicle_indicator, -- Luxury vehicle indicator
        "FULL_CVG_IND" AS full_coverage_indicator, -- Full coverage indicator
        "YTHFL_RDRVR_IND" AS youthful_rated_driver_indicator, -- Youthful rated driver indicator
        "GOOD_DRVR_IND" AS good_driver_indicator, -- Good driver indicator
        "GOOD_STDNT_IND" AS good_student_indicator, -- Good student indicator
        "YES_IND" AS yes_indicator, -- Yes indicator
        "MAT_DRVR_DISC_IND" AS mature_driver_discount_indicator, -- Mature driver discount indicator
        "SAFE_DRVNG_DISC_IND" AS safe_driving_discount_indicator, -- Safe driving discount indicator
        "COMPRE_WTHT_COLL_SURCHRG_IND" AS comprehensive_without_collision_surcharge_indicator, -- Comprehensive without collision surcharge indicator
        "ERLY_SHOPPNG_DISC_IND" AS early_shopping_discount_indicator, -- Early shopping discount indicator
        "EFT_IND" AS eft_indicator, -- EFT indicator
        "PD_IN_FULL_IND" AS paid_in_full_indicator, -- Paid in full indicator
        "NON_FIG_HO_CRED_IND" AS non_figure_homeowner_credit_indicator, -- Non-figure homeowner credit indicator
        "TRNSFR_DISC_IND" AS transfer_discount_indicator, -- Transfer discount indicator
        "MLT_CAR_IND" AS multi_car_indicator, -- Multi-car indicator
        "MLT_LINE_IND" AS multi_line_indicator, -- Multi-line indicator
        "NEW_HH_IND" AS new_household_indicator, -- New household indicator
        "SUM_SOI_CHK_SUM" AS summary_soi_checksum, -- Summary SOI checksum
        "SUM_SOI_SK" AS summary_soi_sk, -- Summary SOI SK
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id, -- Workflow run ID
        "CA_SNR_DRVR_DISC_IND" AS california_senior_driver_discount_indicator, -- California senior driver discount indicator
        "CA_STDNT_AWAY_IND" AS california_student_away_indicator -- California student away indicator
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_MINI_SOI') }}
)
SELECT
    mini_soi_sk,
    checksum_attribute,
    vehicle_type_code,
    vehicle_type_description,
    soi_category,
    vehicle_use_code,
    mca_point_count_range,
    annual_mileage_range,
    car_symbol_range,
    rated_driver_age_range,
    rate_class_code,
    occupation_code,
    occupation_description,
    occupation_code_program,
    collision_deductible,
    california_painted_indicator,
    group_discount_indicator,
    new_car_credit_indicator,
    retirement_community_discount_indicator,
    vehicle_use_surcharge_indicator,
    luxury_vehicle_indicator,
    full_coverage_indicator,
    youthful_rated_driver_indicator,
    good_driver_indicator,
    good_student_indicator,
    yes_indicator,
    mature_driver_discount_indicator,
    safe_driving_discount_indicator,
    comprehensive_without_collision_surcharge_indicator,
    early_shopping_discount_indicator,
    eft_indicator,
    paid_in_full_indicator,
    non_figure_homeowner_credit_indicator,
    transfer_discount_indicator,
    multi_car_indicator,
    multi_line_indicator,
    new_household_indicator,
    summary_soi_checksum,
    summary_soi_sk,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id,
    california_senior_driver_discount_indicator,
    california_student_away_indicator
FROM dim_ag_mini_soi