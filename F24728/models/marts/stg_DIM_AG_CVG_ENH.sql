{{ config(materialized='view') }}

SELECT
"ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
"PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
"SOI_ID" AS soi_id, -- SOI ID
"CVG_CD" AS cvg_cd, -- Coverage code
"LOB" AS lob, -- Line of business
"SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
"EFF_DT" AS eff_dt, -- Effective date
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd, -- On/off premium type record
"REGSTR_PER_SK" AS regstr_per_sk, -- Registration period surrogate key
"DIP" AS dip, -- DIP
"SAP_CMPY" AS sap_cmpy, -- SAP company
"NC_TIER" AS nc_tier, -- NC tier
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse create timestamp
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID
"NJ_FRGVN_PNTS" AS nj_frgvn_pnts, -- NJ forgiven points
"NJ_RTD_PNTS" AS nj_rtd_pnts, -- NJ rated points
"CVG_TYP_IND" AS cvg_typ_ind, -- Coverage type indicator
"DRV_RCRD_SRCHRG_PCT" AS drv_rcrd_srchrg_pct, -- Driver record surcharge percentage
"FARA_CD" AS fara_cd -- FARA code
FROM {{ source('POWER_CENTER', 'DIM_AG_CVG_ENH') }}