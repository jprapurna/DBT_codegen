{{
  config(
    materialized='ephemeral'
  )
}}

WITH source_data AS (
  SELECT * FROM {{ source('source_system', 'table_name') }}
),

exptrans_step AS (
  SELECT *
  FROM {{ mplt_EXPTRANS(
    niss_aprm_dtl_sk=NISS_APRM_DETL_SK,
    st_abbr=ST_ABBR,
    acctng_lob=ACCTNG_LOB,
    bi_lmt=BI_LMT,
    prd_grp_cd=PRD_GRP_CD,
    nj_no_lwst_lmt_ind=NJ_NO_LWST_LMT_IND,
    nj_nmd_drvr_excl_ind=NJ_NMD_DRVR_EXCL_IND,
    cvg_typ_cd=CVG_TYP_CD
  ) }}
),

final AS (
  SELECT *
  FROM exptrans_step
)

SELECT *
FROM final