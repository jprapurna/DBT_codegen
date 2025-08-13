{{ config(materialized='view') }}

SELECT
"PLCY_ENH_SK" AS plcy_enh_sk, -- Surrogate key for policy enhancement
"PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
"SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
"SRC_EFF_DT" AS src_eff_dt, -- Source effective date
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd, -- On/off premium type record
"CIF_CD" AS cif_cd, -- CIF code
"CIF_CD_DESC" AS cif_cd_desc, -- CIF code description
"E_PLCY_IND" AS e_plcy_ind, -- E policy indicator
"E_PLCY_SRC_CD" AS e_plcy_src_cd, -- E policy source code
"E_PLCY_SRC_CD_DESC" AS e_plcy_src_cd_desc, -- E policy source code description
"DISTNT_STDNT_DISC_IND" AS distnt_stdnt_disc_ind, -- Distant student discount indicator
"AUTO_SPLTY_MTRC_DISC_IND" AS auto_splty_mtrc_disc_ind, -- Auto specialty metric discount indicator
"AUTO_SPLTY_BOAT_WC_DISC_IND" AS auto_splty_boat_wc_disc_ind, -- Auto specialty boat WC discount indicator
"AUTO_SPLTY_OFFRD_OTH_DISC_IND" AS auto_splty_offrd_oth_disc_ind, -- Auto specialty offered other discount indicator
"AUTO_SPLTY_MTRHM_TRLR_DISC_IND" AS auto_splty_mtrhm_trlr_disc_ind, -- Auto specialty motorhome trailer discount indicator
"DRVR_IMPRV_DISC_IND" AS drvr_imprv_disc_ind, -- Driver improvement discount indicator
"DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind, -- Defensive driver discount indicator
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse create timestamp
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
"DW_UPD_TMSP" AS dw_upd_tmsp -- Data warehouse update timestamp
FROM {{ source('POWER_CENTER', 'DIM_AG_PLCY_ENH') }}