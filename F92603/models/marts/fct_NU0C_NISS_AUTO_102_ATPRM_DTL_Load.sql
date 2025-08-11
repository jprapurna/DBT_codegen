-- Purpose: Load detailed data for NISS auto territory reporting

WITH detailed_data AS (
    SELECT 
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.REF_AUTO_TERR_SK,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.END_EFF_DT,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.CHCKSUM,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.CR_BY_MAPNG_ID,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.DW_CR_TMSP,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.UPD_BY_MAPNG_ID,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.DW_UPD_TMSP,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.WRK_FLOW_RUN_ID,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.NISS_TERR_CD,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.CNTY_NM,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.CITY_NM,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.SRC_EFF_DT,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.SRC_OBSLT_DT,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.NISS_ST_CD,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.ST_ABBRV,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.ZIP_CD,
        int_LKP_RBI_REF_AUTO_TERR_ByStZipLob.PP_COMMRCL_CD
    FROM {{ ref('int_LKP_RBI_REF_AUTO_TERR_ByStZipLob') }}
)

SELECT 
    detailed_data.REF_AUTO_TERR_SK,
    detailed_data.END_EFF_DT,
    detailed_data.CHCKSUM,
    detailed_data.CR_BY_MAPNG_ID,
    detailed_data.DW_CR_TMSP,
    detailed_data.UPD_BY_MAPNG_ID,
    detailed_data.DW_UPD_TMSP,
    detailed_data.WRK_FLOW_RUN_ID,
    detailed_data.NISS_TERR_CD,
    detailed_data.CNTY_NM,
    detailed_data.CITY_NM,
    detailed_data.SRC_EFF_DT,
    detailed_data.SRC_OBSLT_DT,
    detailed_data.NISS_ST_CD,
    detailed_data.ST_ABBRV,
    detailed_data.ZIP_CD,
    detailed_data.PP_COMMRCL_CD
FROM detailed_data