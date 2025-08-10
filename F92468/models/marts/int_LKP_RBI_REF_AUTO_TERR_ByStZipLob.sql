-- Purpose: Fetch territory details based on state, abbreviation, zip code, and commercial code using SQL override

WITH territory_details AS (
    SELECT 
        REF.REF_AUTO_TERR_SK AS ref_auto_terr_sk,
        REF.END_EFF_DT AS end_eff_dt,
        REF.CHCKSUM AS chcksum,
        REF.CR_BY_MAPNG_ID AS cr_by_mapng_id,
        REF.DW_CR_TMSP AS dw_cr_tmsp,
        REF.UPD_BY_MAPNG_ID AS upd_by_mapng_id,
        REF.DW_UPD_TMSP AS dw_upd_tmsp,
        REF.WRK_FLOW_RUN_ID AS wrk_flow_run_id,
        REF.NISS_TERR_CD AS niss_terr_cd,
        REF.CNTY_NM AS cnty_nm,
        REF.CITY_NM AS city_nm,
        REF.SRC_EFF_DT AS src_eff_dt,
        REF.SRC_OBSLT_DT AS src_obstlt_dt,
        REF.NISS_ST_CD AS niss_st_cd,
        REF.ST_ABBRV AS st_abbrv,
        REF.ZIP_CD AS zip_cd,
        REF.PP_COMMRCL_CD AS pp_commrcl_cd
    FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }} REF
    WHERE REF.END_EFF_DT = '2999-12-31'
    ORDER BY niss_st_cd, st_abbrv, zip_cd, pp_commrcl_cd
)

SELECT 
    niss_st_cd,
    st_abbrv,
    zip_cd,
    pp_commrcl_cd
FROM territory_details