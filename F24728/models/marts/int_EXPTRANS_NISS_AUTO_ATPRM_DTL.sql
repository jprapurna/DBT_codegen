-- Purpose: To process fields with direct expressions, maintaining input/output consistency.
WITH source_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        ST_ABBR,
        ACCTNG_LOB,
        BI_LMT,
        PRD_GRP_CD,
        NJ_NO_LWST_LMT_IND,
        NJ_NMD_DRVR_EXCL_IND,
        CVG_TYP_CD
    FROM {{ source('power_center', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
FROM source_data