{{ config(materialized='view') }}

SELECT
"RATED_GEO_SK" AS rated_geo_sk,
"CHK_SUM_ATTR" AS chk_sum_attr,
"GRGNG_ZIP_3" AS grgng_zip_3,
"GRGNG_ZIP_5" AS grgng_zip_5,
"GRGNG_ZIP_PLUS4" AS grgng_zip_plus4,
"FARMR_GEO_ST_SK" AS farmr_geo_st_sk,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp,
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id
FROM {{ source('staging', 'DIM_AG_RATED_GEO') }}