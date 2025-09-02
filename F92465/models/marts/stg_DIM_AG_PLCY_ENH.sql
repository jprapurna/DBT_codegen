{{ config(materialized='view') }}

WITH dim_ag_plcy_enh AS (
    SELECT
        "PLCY_ENH_SK" AS policy_enhancement_sk, -- Primary key for policy enhancement
        "PLCY_ID_SK" AS policy_id_sk, -- Policy ID SK
        "SRC_TRANS_TMSP" AS source_transaction_timestamp, -- Source transaction timestamp
        "SRC_EFF_DT" AS source_effective_date, -- Source effective date
        "ON_OFF_PREM_TYP_RECRD" AS on_off_premium_type_record, -- On/off premium type record
        "CIF_CD" AS cif_code, -- CIF code
        "CIF_CD_DESC" AS cif_code_description, -- CIF code description
        "E_PLCY_IND" AS e_policy_indicator, -- E-policy indicator
        "E_PLCY_SRC_CD" AS e_policy_source_code, -- E-policy source code
        "E_PLCY_SRC_CD_DESC" AS e_policy_source_code_description, -- E-policy source code description
        "DISTNT_STDNT_DISC_IND" AS distant_student_discount_indicator, -- Distant student discount indicator
        "AUTO_SPLTY_MTRC_DISC_IND" AS auto_specialty_metric_discount_indicator, -- Auto specialty metric discount indicator
        "AUTO_SPLTY_BOAT_WC_DISC_IND" AS auto_specialty_boat_wc_discount_indicator, -- Auto specialty boat WC discount indicator
        "AUTO_SPLTY_OFFRD_OTH_DISC_IND" AS auto_specialty_offered_other_discount_indicator, -- Auto specialty offered other discount indicator
        "AUTO_SPLTY_MTRHM_TRLR_DISC_IND" AS auto_specialty_motorhome_trailer_discount_indicator, -- Auto specialty motorhome trailer discount indicator
        "DRVR_IMPRV_DISC_IND" AS driver_improvement_discount_indicator, -- Driver improvement discount indicator
        "DEFNS_DRVR_DISC_IND" AS defensive_driver_discount_indicator, -- Defensive driver discount indicator
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp -- Data warehouse update timestamp
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_PLCY_ENH') }}
)
SELECT
    policy_enhancement_sk,
    policy_id_sk,
    source_transaction_timestamp,
    source_effective_date,
    on_off_premium_type_record,
    cif_code,
    cif_code_description,
    e_policy_indicator,
    e_policy_source_code,
    e_policy_source_code_description,
    distant_student_discount_indicator,
    auto_specialty_metric_discount_indicator,
    auto_specialty_boat_wc_discount_indicator,
    auto_specialty_offered_other_discount_indicator,
    auto_specialty_motorhome_trailer_discount_indicator,
    driver_improvement_discount_indicator,
    defensive_driver_discount_indicator,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp
FROM dim_ag_plcy_enh