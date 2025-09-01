{{ config(materialized='view') }}

SELECT
    "ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
    "REGSTR_PER_SK" AS regstr_per_sk, -- Surrogate key for registration period
    "SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
    "TRANS_DT_SK" AS trans_dt_sk, -- Surrogate key for transaction date
    "DNSTRM_DT_SK" AS dnstrm_dt_sk, -- Surrogate key for downstream date
    "EFF_DT_SK" AS eff_dt_sk, -- Surrogate key for effective date
    "TERM_STRT_DT_SK" AS term_strt_dt_sk, -- Surrogate key for term start date
    "FISC_PER_SK" AS fisc_per_sk, -- Surrogate key for fiscal period
    "ADJ_PER_SK" AS adj_per_sk, -- Surrogate key for adjustment period
    "PLCY_PER_SK" AS plcy_per_sk, -- Surrogate key for policy period
    "TRANS_TYP_SK" AS trans_typ_sk, -- Surrogate key for transaction type
    "TRANS_TYP_PLCY_SK" AS trans_typ_plcy_sk, -- Surrogate key for transaction type policy
    "MINI_HH_SK" AS mini_hh_sk, -- Surrogate key for mini household
    "MINI_PLCY_SK" AS mini_plcy_sk, -- Surrogate key for mini policy
    "MINI_SOI_SK" AS mini_soi_sk, -- Surrogate key for mini SOI
    "MINI_CVG_SK" AS mini_cvg_sk, -- Surrogate key for mini coverage
    "MINI_AGT_SK" AS mini_agt_sk, -- Surrogate key for mini agent
    "MINI_RDRVR_SK" AS mini_rdrvr_sk, -- Surrogate key for mini driver
    "HH_SK" AS hh_sk, -- Surrogate key for household
    "PLCY_SK" AS plcy_sk, -- Surrogate key for policy
    "SOI_SK" AS soi_sk, -- Surrogate key for SOI
    "CVG_SK" AS cvg_sk, -- Surrogate key for coverage
    "PNI_SK" AS pni_sk, -- Surrogate key for PNI
    "AGT_SK" AS agt_sk, -- Surrogate key for agent
    "RDRVR_SK" AS rdrvr_sk, -- Surrogate key for driver
    "FARMR_GEO_DISTR_SK" AS farmr_geo_distr_sk, -- Surrogate key for farmer geo distribution
    "RATED_GEO_SK" AS rated_geo_sk, -- Surrogate key for rated geo
    "DNSTRM_REGSTR_PER_SK" AS dnstrm_regstr_per_sk, -- Surrogate key for downstream registration period
    "DNSTRM_FISC_PER_SK" AS dnstrm_fisc_per_sk, -- Surrogate key for downstream fiscal period
    "MINI_PNI_SK" AS mini_pni_sk, -- Surrogate key for mini PNI
    "DC_VER_IND_CVG" AS dc_ver_ind_cvg, -- Verification indicator for coverage
    "DC_VER_IND_SOI" AS dc_ver_ind_soi, -- Verification indicator for SOI
    "DC_VER_IND_PLCY" AS dc_ver_ind_plcy, -- Verification indicator for policy
    "ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd, -- Record type for on/off premium
    "PLCY_KOR_CD" AS plcy_kor_cd, -- Policy KOR code
    "UNIT_KOR_CD" AS unit_kor_cd, -- Unit KOR code
    "WRITTN_PREM_AMT" AS writtn_prem_amt, -- Written premium amount
    "TTL_WRITTN_PREM_AMT" AS ttl_writtn_prem_amt, -- Total written premium amount
    "UNCAP_WRITTN_PREM_AMT" AS uncap_writtn_prem_amt, -- Uncapped written premium amount
    "ALLOC_TDC_AMT" AS alloc_tdc_amt, -- Allocated TDC amount
    "ALLOC_MANL_ADJ_AMT" AS alloc_manl_adj_amt, -- Allocated manual adjustment amount
    "ALLOC_ASGN_RSK_INSTL_FEE_AMT" AS alloc_asgn_rsk_instl_fee_amt, -- Allocated assigned risk installation fee amount
    "ALLOC_EP_WRIT_OFF_AMT" AS alloc_ep_writ_off_amt, -- Allocated EP write-off amount
    "CVG_EXPS_VAL" AS cvg_exps_val, -- Coverage expense value
    "PLCY_FEE_AMT" AS plcy_fee_amt, -- Policy fee amount
    "DRVR_FILNG_FEE_AMT" AS drvr_filng_fee_amt, -- Driver filing fee amount
    "REINST_FEE_AMT" AS reinst_fee_amt, -- Reinstatement fee amount
    "PREM_CAP_FCTR" AS prem_cap_fctr, -- Premium cap factor
    "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
    "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
    "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
    "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
    "WRK_FLOW_RUN_ID" AS wrk_flow_run_id, -- Workflow run ID
    "FULL_TERM_PREM_AMT" AS full_term_prem_amt, -- Full term premium amount
    "PLCY_ENH_SK" AS plcy_enh_sk, -- Surrogate key for policy enhancement
    "SOI_ENH_SK" AS soi_enh_sk, -- Surrogate key for SOI enhancement
    "REGSTR_CUST_SGMTN_SK" AS regstr_cust_sgmtn_sk, -- Surrogate key for registration customer segmentation
    "TERM_CUST_SGMTN_SK" AS term_cust_sgmtn_sk, -- Surrogate key for term customer segmentation
    "REGSTR_CUST_SGMTN_V2_SK" AS regstr_cust_sgmtn_v2_sk, -- Surrogate key for registration customer segmentation version 2
    "TERM_CUST_SGMTN_V2_SK" AS term_cust_sgmtn_v2_sk, -- Surrogate key for term customer segmentation version 2
    "FL_HURR_CAT_FUND_AMT" AS fl_hurr_cat_fund_amt, -- Florida hurricane catastrophe fund amount
    "FL_CPIC_REG_ASSMNT_AMT" AS fl_cpic_reg_assmnt_amt, -- Florida CPIC regular assessment amount
    "FL_CPIC_EMERG_SURCHRG_AMT" AS fl_cpic_emerg_surchrg_amt, -- Florida CPIC emergency surcharge amount
    "FL_IGA_REG_AMT" AS fl_iga_reg_amt, -- Florida IGA regular amount
    "FL_IGA_EMERG_AMT" AS fl_iga_emerg_amt -- Florida IGA emergency amount
FROM {{ source('genai_power_bi', 'FACT_AG_WRITTN_PREM_CVG_LVL') }}