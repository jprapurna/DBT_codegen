WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC,
        {{ safe_cast_to_integer('AGE') }} AS IAGE,
        {{ safe_cast_to_integer('MILES_TO_WRK') }} AS IMILES_TO_WRK
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
),
class_code_logic AS (
    SELECT
        *
    FROM base_data
)
SELECT * FROM class_code_logic
