{{ config(materialized='view') }}

WITH rbi_ref_auto_terr AS (
    SELECT
        "REF_AUTO_TERR_SK" AS ref_auto_territory_sk, -- Primary key for auto territory reference
        "END_EFF_DT" AS end_effective_date, -- End effective date
        "CHCKSUM" AS checksum_value, -- Checksum value
        "CR_BY_MAPNG_ID" AS created_by_mapping_id, -- Created by mapping ID
        "DW_CR_TMSP" AS data_warehouse_creation_timestamp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS updated_by_mapping_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS data_warehouse_update_timestamp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS workflow_run_id, -- Workflow run ID
        "NISS_TERR_CD" AS niss_territory_code, -- NISS territory code
        "CNTY_NM" AS county_name, -- County name
        "CITY_NM" AS city_name, -- City name
        "SRC_EFF_DT" AS source_effective_date, -- Source effective date
        "SRC_OBSLT_DT" AS source_obsolete_date, -- Source obsolete date
        "NISS_ST_CD" AS niss_state_code, -- NISS state code
        "ST_ABBRV" AS state_abbreviation, -- State abbreviation
        "ZIP_CD" AS zip_code, -- ZIP code
        "PP_COMMRCL_CD" AS pp_commercial_code -- PP commercial code
    FROM {{ source('GENAI_POWER_BI', 'RBI_REF_AUTO_TERR') }}
)
SELECT
    ref_auto_territory_sk,
    end_effective_date,
    checksum_value,
    created_by_mapping_id,
    data_warehouse_creation_timestamp,
    updated_by_mapping_id,
    data_warehouse_update_timestamp,
    workflow_run_id,
    niss_territory_code,
    county_name,
    city_name,
    source_effective_date,
    source_obsolete_date,
    niss_state_code,
    state_abbreviation,
    zip_code,
    pp_commercial_code
FROM rbi_ref_auto_terr