{% macro mplt_EXPTRANS(niss_aprm_dtl_sk, st_abbr, acctng_lob, bi_lmt, prd_grp_cd, nj_no_lwst_lmt_ind, nj_nmd_drvr_excl_ind, cvg_typ_cd) %}
WITH exptrans_step AS (
  SELECT
    {{ niss_aprm_dtl_sk }} AS NISS_APRM_DETL_SK,
    {{ st_abbr }} AS ST_ABBR,
    {{ acctng_lob }} AS ACCTNG_LOB,
    {{ bi_lmt }} AS BI_LMT,
    {{ prd_grp_cd }} AS PRD_GRP_CD,
    {{ nj_no_lwst_lmt_ind }} AS NJ_NO_LWST_LMT_IND,
    {{ nj_nmd_drvr_excl_ind }} AS NJ_NMD_DRVR_EXCL_IND,
    {{ cvg_typ_cd }} AS CVG_TYP_CD
)
SELECT *
FROM exptrans_step
{% endmacro %}