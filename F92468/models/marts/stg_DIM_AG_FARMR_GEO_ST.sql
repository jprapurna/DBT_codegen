{{ config(materialized='view') }}

SELECT
"FARMR_GEO_ST_SK" AS farmr_geo_st_sk,
"CHK_SUM_ATTR" AS chk_sum_attr,
"ST_CD" AS st_cd,
"ST_NM" AS st_nm,
"ZONE" AS zone,
"CORE_29_IND" AS core_29_ind,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp,
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id
FROM {{ source('staging', 'DIM_AG_FARMR_GEO_ST') }}