-- Inputs: Upstream model WRK_BIRP_NISS_APRM_DETL.

WITH source_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC,
    CASE
        WHEN REC_EXCP_IND = 'INSERT' THEN 'INSERT'
        WHEN REC_EXCP_IND = 'UPDATE' THEN 'UPDATE'
        ELSE 'NC'
    END AS update_flag
FROM source_data;