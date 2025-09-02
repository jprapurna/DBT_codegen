{{ config(materialized='view') }}

WITH dim_ag_cvg_enh AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_premium_sk, -- On/off premium SK
        "PLCY_ID_SK" AS policy_id_sk, -- Policy ID SK
        "SOI_ID" AS soi_id, -- SOI ID
        "CVG_CD" AS coverage_code, -- Coverage code
        "LOB" AS line_of_business, -- Line of business
        "SRC_TRANS_TMSP" AS source_transaction_timestamp, -- Source transaction timestamp
        "EFF_DT" AS effective_date, -- Effective date
        "ON_OFF_PREM_TYP_RECRD" AS on_off_premium_type_record, -- On/off premium type record
        "REGSTR_PER_SK" AS registration_period_sk, -- Registration period SK
        "DIP" AS dip, -- DIP
        "SAP_CMPY" AS sap_company, -- SAP company
        "NC_TIER" AS nc_tier, -- NC tier
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id, -- Workflow run ID
        "NJ_FRGVN_PNTS" AS new_jersey_forgiven_points, -- New Jersey forgiven points
        "NJ_RTD_PNTS" AS new_jersey_rated_points, -- New Jersey rated points
        "CVG_TYP_IND" AS coverage_type_indicator, -- Coverage type indicator
        "DRV_RCRD_SRCHRG_PCT" AS driver_record_surcharge_percentage, -- Driver record surcharge percentage
        "FARA_CD" AS fara_code -- FARA code
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_CVG_ENH') }}
)
SELECT
    on_off_premium_sk,
    policy_id_sk,
    soi_id,
    coverage_code,
    line_of_business,
    source_transaction_timestamp,
    effective_date,
    on_off_premium_type_record,
    registration_period_sk,
    dip,
    sap_company,
    nc_tier,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id,
    new_jersey_forgiven_points,
    new_jersey_rated_points,
    coverage_type_indicator,
    driver_record_surcharge_percentage,
    fara_code
FROM dim_ag_cvg_enh