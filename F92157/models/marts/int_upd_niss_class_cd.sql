WITH source_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
),
updated_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC,
        CASE
            WHEN DD_UPDATE = 'INSERT' THEN 'INSERT'
            WHEN DD_UPDATE = 'UPDATE' THEN 'UPDATE'
            ELSE 'NC'
        END AS update_flag
    FROM source_data
)

SELECT *
FROM updated_data;