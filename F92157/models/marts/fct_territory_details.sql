{{ config(materialized='table') }}
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
FROM {{ ref('int_territory_lookup') }}
