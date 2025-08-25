    WITH territory_details AS (
        SELECT
            NISS_ST_CD,
            ST_ABBRV,
            ZIP_CD,
            PP_COMMRCL_CD,
            REF_AUTO_TERR_SK,
            END_EFF_DT,
            CHCKSUM,
            CR_BY_MAPNG_ID,
            DW_CR_TMSP,
            UPD_BY_MAPNG_ID,
            DW_UPD_TMSP,
            WRK_FLOW_RUN_ID,
            NISS_TERR_CD,
            CNTY_NM,
            CITY_NM,
            SRC_EFF_DT,
            SRC_OBSLT_DT
    FROM {{ source('CDM', 'territory_details') }}
    )
    SELECT *
    FROM territory_details