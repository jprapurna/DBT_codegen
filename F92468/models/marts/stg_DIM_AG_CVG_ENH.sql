{{ config(materialized='view') }}

SELECT
"ON_OFF_PREM_SK" AS on_off_prem_sk,
"PLCY_ID_SK" AS plcy_id_sk,
"SOI_ID" AS soi_id,
"CVG_CD" AS cvg_cd,
"LOB" AS lob,
"SRC_TRANS_TMSP" AS src_trans_tmsp,
"EFF_DT" AS eff_dt,
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd,
"REGSTR_PER_SK" AS regstr_per_sk,
"DIP" AS dip,
"SAP_CMPY" AS sap_cmpy,
"NC_TIER" AS nc_tier,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp,
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id,
"NJ_FRGVN_PNTS" AS nj_frgvn_pnts,
"NJ_RTD_PNTS" AS nj_rtd_pnts,
"CVG_TYP_IND" AS cvg_typ_ind,
"DRV_RCRD_SRCHRG_PCT" AS drv_rcrd_srchrg_pct,
"FARA_CD" AS fara_cd
FROM {{ source('staging', 'DIM_AG_CVG_ENH') }}