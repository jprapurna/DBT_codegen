{{ config(materialized='view') }}

WITH dim_ag_rated_geo AS (
    SELECT
        "RATED_GEO_SK" AS rated_geographic_sk, -- Primary key for rated geographic
        "CHK_SUM_ATTR" AS checksum_attribute, -- Checksum attribute
        "GRGNG_ZIP_3" AS garage_zip_code_3_digits, -- Garage ZIP code (3 digits)
        "GRGNG_ZIP_5" AS garage_zip_code_5_digits, -- Garage ZIP code (5 digits)
        "GRGNG_ZIP_PLUS4" AS garage_zip_code_plus_4, -- Garage ZIP code plus 4
        "FARMR_GEO_ST_SK" AS farmer_geographic_state_sk, -- Farmer geographic state SK
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_RATED_GEO') }}
)
SELECT
    rated_geographic_sk,
    checksum_attribute,
    garage_zip_code_3_digits,
    garage_zip_code_5_digits,
    garage_zip_code_plus_4,
    farmer_geographic_state_sk,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id
FROM dim_ag_rated_geo