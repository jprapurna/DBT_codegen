-- Purpose: Fetch territory details based on state, abbreviation, zip code, and commercial code using SQL override. Handles data transformation and assignment.

WITH territory_lookup AS (
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
        REF.SRC_OBSLT_DT AS src_obstl_dt,
        REF.NISS_ST_CD AS niss_st_cd,
        REF.ST_ABBRV AS st_abbrv,
        REF.ZIP_CD AS zip_cd,
        REF.PP_COMMRCL_CD AS pp_commrcl_cd
    FROM 
        {{ source('BIRP', 'RBI_REF_AUTO_TERR') }} REF
    WHERE 
        REF.END_EFF_DT = '2999-12-31'
    ORDER BY 
        NISS_ST_CD, ST_ABBRV, ZIP_CD, PP_COMMRCL_CD
)

SELECT 
    niss_st_cd,
    st_abbrv,
    zip_cd,
    pp_commrcl_cd,
    ref_auto_terr_sk,
    end_eff_dt,
    chcksum,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id,
    niss_terr_cd,
    cnty_nm,
    city_nm,
    src_eff_dt,
    src_obstl_dt
FROM 
    territory_lookup
WHERE 
    niss_st_cd = {{ ref('i_NISS_ST_CD') }} AND
    st_abbrv = {{ ref('i_ST_ABBRV') }} AND
    zip_cd = {{ ref('i_ZIP_CD') }} AND
    pp_commrcl_cd = {{ ref('i_PP_COMMRCL_CD') }}