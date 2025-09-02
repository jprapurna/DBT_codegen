{{ config(materialized='view') }}

WITH farmer_geo_state AS (
    SELECT
        "FARMR_GEO_ST_SK" AS farmr_geo_st_sk, -- Primary key for farmer geographic state
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "ST_CD" AS st_cd, -- State code
        "ST_NM" AS st_nm, -- State name
        "ZONE" AS zone, -- Zone
        "CORE_29_IND" AS core_29_ind, -- Core 29 indicator
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_FARMR_GEO_ST') }}
)
SELECT
    farmr_geo_st_sk,
    chk_sum_attr,
    st_cd,
    st_nm,
    zone,
    core_29_ind,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id
FROM farmer_geo_state