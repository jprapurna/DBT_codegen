{{ config(materialized='view') }}

SELECT
"TRANS_TYP_PLCY_SK" AS trans_typ_plcy_sk,
"TRANS_TYP_PLCY_CD" AS trans_typ_plcy_cd,
"TRANS_TYP_PLCY_DESC" AS trans_typ_plcy_desc,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp,
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id
FROM {{ source('staging', 'DIM_AG_TRANS_TYP_PLCY') }}