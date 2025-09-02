{{ config(materialized='view') }}

WITH wrk_birp_ta_niss_nu0c_aprm_dtl AS (
    SELECT
        "FISC_PER_YR" AS fiscal_period_year, -- Fiscal period year
        "NAIC_CMPNY_CD" AS naic_company_code, -- NAIC company code
        "NISS_CMPNY_CD" AS niss_company_code, -- NISS company code
        "ST_NM" AS state_name, -- State name
        "ST_CD" AS state_code, -- State code
        "NISS_ST_CD" AS niss_state_code, -- NISS state code
        "ST_ABBR" AS state_abbreviation, -- State abbreviation
        "ACCTNG_LOB" AS accounting_line_of_business, -- Accounting line of business
        "CVG_TYP_CD" AS coverage_type_code, -- Coverage type code
        "CVG_AMT" AS coverage_amount, -- Coverage amount
        "BI_LMT" AS bi_limit, -- BI limit
        "GA_ADDED_AT_FAULT_IND" AS georgia_added_at_fault_indicator, -- Georgia added at fault indicator
        "PLCY_IND" AS policy_indicator, -- Policy indicator
        "UM_UMI_STACKING" AS um_umi_stacking, -- UM/UMI stacking
        "PIP_WVR_WL_IND" AS pip_waiver_indicator, -- PIP waiver indicator
        "PIP_MED_SEC_IND" AS pip_medical_section_indicator, -- PIP medical section indicator
        "PIP_LOSS_INCOME_IND" AS pip_loss_income_indicator, -- PIP loss income indicator
        "MI_PPO_IND" AS michigan_ppo_indicator, -- Michigan PPO indicator
        "PRD_GRP_CD" AS product_group_code, -- Product group code
        "NJ_HLTH_INSR_PRIM" AS new_jersey_health_insurance_primary, -- New Jersey health insurance primary
        "NJ_EXTR_PIP_PKG" AS new_jersey_extra_pip_package, -- New Jersey extra PIP package
        "NJ_RESDNC_RLTNSHP_PIP_IND" AS new_jersey_residence_relationship_pip_indicator, -- New Jersey residence relationship PIP indicator
        "NY_SSL_IND" AS new_york_ssl_indicator, -- New York SSL indicator
        "NY_FULL_CVG_GLASS_COMP_IND" AS new_york_full_coverage_glass_comprehensive_indicator, -- New York full coverage glass comprehensive indicator
        "GRGNG_ZIP" AS garage_zip_code, -- Garage ZIP code
        "NISS_TERR_CD" AS niss_territory_code, -- NISS territory code
        "RATNG_CMPY_CD" AS rating_company_code, -- Rating company code
        "MLT_CAR_IND" AS multi_car_indicator, -- Multi-car indicator
        "RT_CLS" AS rating_class, -- Rating class
        "AGE" AS age, -- Age
        "GENDR" AS gender, -- Gender
        "MRTL_STAT" AS marital_status, -- Marital status
        "AUTO_USE_CD" AS auto_use_code, -- Auto use code
        "MILES_TO_WRK" AS miles_to_work, -- Miles to work
        "GOOD_STDNT_IND" AS good_student_indicator, -- Good student indicator
        "DRVR_TRNG_IND" AS driver_training_indicator, -- Driver training indicator
        "SOI_TYP" AS soi_type, -- SOI type
        "PHY_DMG_IND" AS physical_damage_indicator, -- Physical damage indicator
        "NJ_RATD_PNTS" AS new_jersey_rated_points, -- New Jersey rated points
        "VEH_MDL_YR" AS vehicle_model_year, -- Vehicle model year
        "NJ_EXCPTION_CD" AS new_jersey_exception_code, -- New Jersey exception code
        "NJ_FGVN_PNTS" AS new_jersey_forgiven_points, -- New Jersey forgiven points
        "PASSV_RESTRA_DISC" AS passive_restraint_discount, -- Passive restraint discount
        "SNR_DRVR_IND" AS senior_driver_indicator, -- Senior driver indicator
        "DEFNS_DRVR_DISC_IND" AS defensive_driver_discount_indicator, -- Defensive driver discount indicator
        "ANTI_THFT_DISC" AS anti_theft_discount, -- Anti-theft discount
        "DAY_TM_RUN_LIGHTS" AS daytime_running_lights, -- Daytime running lights
        "LMT_TORT" AS limited_tort, -- Limited tort
        "ANNL_STMNT_LOB_CD" AS annual_statement_line_of_business_code, -- Annual statement line of business code
        "CVG_TYP_IND" AS coverage_type_indicator -- Coverage type indicator
    FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}
)
SELECT
    fiscal_period_year,
    naic_company_code,
    niss_company_code,
    state_name,
    state_code,
    niss_state_code,
    state_abbreviation,
    accounting_line_of_business,
    coverage_type_code,
    coverage_amount,
    bi_limit,
    georgia_added_at_fault_indicator,
    policy_indicator,
    um_umi_stacking,
    pip_waiver_indicator,
    pip_medical_section_indicator,
    pip_loss_income_indicator,
    michigan_ppo_indicator,
    product_group_code,
    new_jersey_health_insurance_primary,
    new_jersey_extra_pip_package,
    new_jersey_residence_relationship_pip_indicator,
    new_york_ssl_indicator,
    new_york_full_coverage_glass_comprehensive_indicator,
    garage_zip_code,
    niss_territory_code,
    rating_company_code,
    multi_car_indicator,
    rating_class,
    age,
    gender,
    marital_status,
    auto_use_code,
    miles_to_work,
    good_student_indicator,
    driver_training_indicator,
    soi_type,
    physical_damage_indicator,
    new_jersey_rated_points,
    vehicle_model_year,
    new_jersey_exception_code,
    new_jersey_forgiven_points,
    passive_restraint_discount,
    senior_driver_indicator,
    defensive_driver_discount_indicator,
    anti_theft_discount,
    daytime_running_lights,
    limited_tort,
    annual_statement_line_of_business_code,
    coverage_type_indicator
FROM wrk_birp_ta_niss_nu0c_aprm_dtl