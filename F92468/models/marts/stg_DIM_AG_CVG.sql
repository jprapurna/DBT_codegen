{{ config(materialized='view') }}

SELECT
"CVG_SK" AS cvg_sk,
"CHK_SUM_ATTR" AS chk_sum_attr,
"ACCTNG_LOB" AS acctng_lob,
"LOB" AS lob,
"CVG_TYP_CD" AS cvg_typ_cd,
"CVG_TYP_DESC" AS cvg_typ_desc,
"DED_PCT" AS ded_pct,
"MINI_CVG_SK" AS mini_cvg_sk,
"MINI_CVG_CHK_SUM" AS mini_cvg_chk_sum,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp,
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id
FROM {{ source('staging', 'DIM_AG_CVG') }}