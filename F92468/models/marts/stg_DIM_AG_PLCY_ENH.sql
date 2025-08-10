{{ config(materialized='view') }}

SELECT
"PLCY_ENH_SK" AS plcy_enh_sk,
"PLCY_ID_SK" AS plcy_id_sk,
"SRC_TRANS_TMSP" AS src_trans_tmsp,
"SRC_EFF_DT" AS src_eff_dt,
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd,
"CIF_CD" AS cif_cd,
"CIF_CD_DESC" AS cif_cd_desc,
"E_PLCY_IND" AS e_plcy_ind,
"E_PLCY_SRC_CD" AS e_plcy_src_cd,
"E_PLCY_SRC_CD_DESC" AS e_plcy_src_cd_desc,
"DISTNT_STDNT_DISC_IND" AS distnt_stdnt_disc_ind,
"AUTO_SPLTY_MTRC_DISC_IND" AS auto_splty_mtrc_disc_ind,
"AUTO_SPLTY_BOAT_WC_DISC_IND" AS auto_splty_boat_wc_disc_ind,
"AUTO_SPLTY_OFFRD_OTH_DISC_IND" AS auto_splty_offrd_oth_disc_ind,
"AUTO_SPLTY_MTRHM_TRLR_DISC_IND" AS auto_splty_mtrhm_trlr_disc_ind,
"DRVR_IMPRV_DISC_IND" AS drvr_imprv_disc_ind,
"DEFNS_DRVR_DISC_IND" AS defns_drvr_disc_ind,
"CR_BY_MAPNG_ID" AS cr_by_mapng_id,
"DW_CR_TMSP" AS dw_cr_tmsp,
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id,
"DW_UPD_TMSP" AS dw_upd_tmsp
FROM {{ source('staging', 'DIM_AG_PLCY_ENH') }}