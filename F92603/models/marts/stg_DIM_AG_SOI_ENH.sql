{{ config(materialized='view') }}

SELECT
"SOI_ENH_SK" AS soi_enh_sk, -- Surrogate key for SOI enhancement.
"PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key.
"SOI_ID" AS soi_id, -- SOI ID.
"SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp.
"SRC_EFF_DT" AS src_eff_dt, -- Source effective date.
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd, -- On/off premium type record.
"ADD_UNIT_IND" AS add_unit_ind, -- Add unit indicator.
"RPLC_VEH_IND" AS rplc_veh_ind, -- Replace vehicle indicator.
"DISTNT_STDNT_DISC_IND" AS distnt_stdnt_disc_ind, -- Distant student discount indicator.
"AUTO_SPLTY_MTRC_DISC_IND" AS auto_splty_mtrc_disc_ind, -- Auto specialty metric discount indicator.
"AUTO_SPLTY_BOAT_WC_DISC_IND" AS auto_splty_boat_wc_disc_ind, -- Auto specialty boat WC discount indicator.
"AUTO_SPLTY_OFFRD_OTH_DISC_IND" AS auto_splty_offrd_oth_disc_ind, -- Auto specialty offered other discount indicator.
"AUTO_SPLTY_MTRHM_TRLR_DISC_IND" AS auto_splty_mtrhm_trlr_disc_ind, -- Auto specialty motorhome trailer discount indicator.
"DRVR_IMPRV_DISC_IND" AS drvr_imprv_disc_ind, -- Driver improvement discount indicator.
"DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind, -- Defensive driver discount indicator.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID.
"LSE_VEH_IND" AS lse_veh_ind, -- Lease vehicle indicator.
"MLT_LINE_DISC_DESC" AS mlt_line_disc_desc, -- Multi-line discount description.
"PRD_TYP" AS prd_typ, -- Product type.
"AUTO_USE_CD" AS auto_use_cd, -- Auto use code.
"AUTO_USE_DESC" AS auto_use_desc, -- Auto use description.
"RT_CLS" AS rt_cls, -- Rate class.
"FARM_DISC_CD" AS farm_disc_cd, -- Farm discount code.
"NON_SMKR" AS non_smkr, -- Non-smoker indicator.
"FIRE_TAX_CD_CNTY" AS fire_tax_cd_cnty, -- Fire tax code county.
"FIRE_TAX_CD_CITY" AS fire_tax_cd_city, -- Fire tax code city.
"NEW_BUS_REINSTMT_DT" AS new_bus_reinstmt_dt, -- New business reinstatement date.
"LMT_TORT" AS lmt_tort -- Limit tort.
FROM {{ source('staging', 'DIM_AG_SOI_ENH') }}