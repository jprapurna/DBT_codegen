WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_PLCY_LMT_CD,
        'DD_UPDATE' AS update_flag
   FROM {{ source('PowerExchange_For_Snowflake', 'FDR_LIB_WRK_BIRP_NISS_APRM_DETL1') }}
)

SELECT
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD,
    update_flag
FROM base_data