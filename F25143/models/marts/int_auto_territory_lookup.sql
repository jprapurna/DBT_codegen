WITH territory_lookup AS (
    SELECT
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
    FROM {{ ref('auto_territory_reference') }}
    WHERE NISS_ST_CD = {{ dbt_utils.safe_cast('i_NISS_ST_CD', 'string') }}
      AND ST_ABBRV = {{ dbt_utils.safe_cast('i_ST_ABBRV', 'string') }}
      AND ZIP_CD = {{ dbt_utils.safe_cast('i_ZIP_CD', 'string') }}
      AND PP_COMMRCL_CD = {{ dbt_utils.safe_cast('i_PP_COMMRCL_CD', 'string') }}
)
SELECT *
FROM territory_lookup