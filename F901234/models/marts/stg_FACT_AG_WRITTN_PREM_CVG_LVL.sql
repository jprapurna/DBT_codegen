{{ config(materialized='view') }}

SELECT
"ON_OFF_PREM_SK" AS on_off_prem_sk, -- On/off premium SK.
"REGSTR_PER_SK" AS regstr_per_sk, -- Register period SK.
"SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp.
"TRANS_DT_SK" AS trans_dt_sk, -- Transaction date SK.
"DNSTRM_DT_SK" AS dnstrm_dt_sk, -- Downstream date SK.
"EFF_DT_SK" AS eff_dt_sk, -- Effective date SK.
"TERM_STRT_DT_SK" AS term_strt_dt_sk, -- Term start date SK.
"FISC_PER_SK" AS fisc_per_sk, -- Fiscal period SK.
"ADJ_PER_SK" AS adj_per_sk, -- Adjustment period SK.
"PLCY_PER_SK" AS plcy_per_sk, -- Policy period SK.
"TRANS_TYP_SK" AS trans_typ_sk, -- Transaction type SK.
"TRANS_TYP_PLCY_SK" AS trans_typ_plcy_sk, -- Transaction type policy SK.
"MINI_HH_SK" AS mini_hh_sk, -- Mini household SK.
"MINI_PLCY_SK" AS mini_plcy_sk, -- Mini policy SK.
"MINI_SOI_SK" AS mini_soi_sk, -- Mini SOI SK.
"MINI_CVG_SK" AS mini_cvg_sk, -- Mini coverage SK.
"MINI_AGT_SK" AS mini_agt_sk, -- Mini agent SK.
"MINI_RDRVR_SK" AS mini_rdrvr_sk, -- Mini driver SK.
"HH_SK" AS hh_sk, -- Household SK.
"PLCY_SK" AS plcy_sk, -- Policy SK.
"SOI_SK" AS soi_sk, -- SOI SK.
"CVG_SK" AS cvg_sk, -- Coverage SK.
"PNI_SK" AS pni_sk, -- PNI SK.
"AGT_SK" AS agt_sk, -- Agent SK.
"RDRVR_SK" AS rdrvr_sk, -- Driver SK.
"FARMR_GEO_DISTR_SK" AS farmr_geo_distr_sk, -- Farmer geographic district SK.
"RATED_GEO_SK" AS rated_geo_sk, -- Rated geographic SK.
"DNSTRM_REGSTR_PER_SK" AS dnstrm_regstr_per_sk, -- Downstream register period SK.
"DNSTRM_FISC_PER_SK" AS dnstrm_fisc_per_sk, -- Downstream fiscal period SK.
"MINI_PNI_SK" AS mini_pni_sk, -- Mini PNI SK.
"DC_VER_IND_CVG" AS dc_ver_ind_cvg, -- DC verification indicator coverage.
"DC_VER_IND_SOI" AS dc_ver_ind_soi, -- DC verification indicator SOI.
"DC_VER_IND_PLCY" AS dc_ver_ind_plcy, -- DC verification indicator policy.
"ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd, -- On/off premium type record.
"PLCY_KOR_CD" AS plcy_kor_cd, -- Policy KOR code.
"UNIT_KOR_CD" AS unit_kor_cd, -- Unit KOR code.
"WRITTN_PREM_AMT" AS writtn_prem_amt, -- Written premium amount.
"TTL_WRITTN_PREM_AMT" AS ttl_writtn_prem_amt, -- Total written premium amount.
"UNCAP_WRITTN_PREM_AMT" AS uncap_writtn_prem_amt, -- Uncapped written premium amount.
"ALLOC_TDC_AMT" AS alloc_tdc_amt, -- Allocated TDC amount.
"ALLOC_MANL_ADJ_AMT" AS alloc_manl_adj_amt, -- Allocated manual adjustment amount.
"ALLOC_ASGN_RSK_INSTL_FEE_AMT" AS alloc_asgn_rsk_instl_fee_amt, -- Allocated assigned risk installation fee amount.
"ALLOC_EP_WRIT_OFF_AMT" AS alloc_ep_writ_off_amt, -- Allocated EP write-off amount.
"CVG_EXPS_VAL" AS cvg_exps_val, -- Coverage expenses value.
"PLCY_FEE_AMT" AS plcy_fee_amt, -- Policy fee amount.
"DRVR_FILNG_FEE_AMT" AS drvr_filng_fee_amt, -- Driver filing fee amount.
"REINST_FEE_AMT" AS reinst_fee_amt, -- Reinstatement fee amount.
"PREM_CAP_FCTR" AS prem_cap_fctr, -- Premium cap factor.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID.
"FULL_TERM_PREM_AMT" AS full_term_prem_amt, -- Full term premium amount.
"PLCY_ENH_SK" AS plcy_enh_sk, -- Policy enhancement SK.
"SOI_ENH_SK" AS soi_enh_sk, -- SOI enhancement SK.
"REGSTR_CUST_SGMTN_SK" AS regstr_cust_sgmtn_sk, -- Register customer segmentation SK.
"TERM_CUST_SGMTN_SK" AS term_cust_sgmtn_sk, -- Term customer segmentation SK.
"REGSTR_CUST_SGMTN_V2_SK" AS regstr_cust_sgmtn_v2_sk, -- Register customer segmentation V2 SK.
"TERM_CUST_SGMTN_V2_SK" AS term_cust_sgmtn_v2_sk, -- Term customer segmentation V2 SK.
"FL_HURR_CAT_FUND_AMT" AS fl_hurr_cat_fund_amt, -- FL hurricane catastrophe fund amount.
"FL_CPIC_REG_ASSMNT_AMT" AS fl_cpic_reg_assmnt_amt, -- FL CPIC regular assessment amount.
"FL_CPIC_EMERG_SURCHRG_AMT" AS fl_cpic_emerg_surchrg_amt, -- FL CPIC emergency surcharge amount.
"FL_IGA_REG_AMT" AS fl_iga_reg_amt, -- FL IGA regular amount.
"FL_IGA_EMERG_AMT" AS fl_iga_emerg_amt -- FL IGA emergency amount.
FROM {{ source('FACT_AG_WRITTN_PREM_CVG_LVL', 'FACT_AG_WRITTN_PREM_CVG_LVL') }}