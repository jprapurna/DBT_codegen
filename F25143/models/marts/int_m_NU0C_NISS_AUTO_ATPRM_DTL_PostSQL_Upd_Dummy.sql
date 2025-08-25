{{ config(materialized='view') }}

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
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT *
FROM source_data;