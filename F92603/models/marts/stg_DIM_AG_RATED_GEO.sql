{{ config(materialized='view') }}

SELECT
"RATED_GEO_SK" AS rated_geo_sk, -- Surrogate key for rated geographic information.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"GRGNG_ZIP_3" AS grgng_zip_3, -- Garage zip code (3 digits).
"GRGNG_ZIP_5" AS grgng_zip_5, -- Garage zip code (5 digits).
"GRGNG_ZIP_PLUS4" AS grgng_zip_plus4, -- Garage zip code (plus 4 digits).
"FARMR_GEO_ST_SK" AS farmr_geo_st_sk, -- Farmer geographic state surrogate key.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID.
FROM {{ source('staging', 'DIM_AG_RATED_GEO') }}