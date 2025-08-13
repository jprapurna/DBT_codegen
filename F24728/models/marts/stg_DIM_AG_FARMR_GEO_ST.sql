{{ config(materialized='view') }}

SELECT
"FARMR_GEO_ST_SK" AS farmr_geo_st_sk, -- Surrogate key for farmer geographic state
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
"ST_CD" AS st_cd, -- State code
"ST_NM" AS st_nm, -- State name
"ZONE" AS zone, -- Zone
"CORE_29_IND" AS core_29_ind, -- Core 29 indicator
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse create timestamp
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID
FROM {{ source('POWER_CENTER', 'DIM_AG_FARMR_GEO_ST') }}