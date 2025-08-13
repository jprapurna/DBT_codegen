-- Purpose: Update strategy transformation for NISS_CLASS_CD
WITH source_data AS (
    SELECT 
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC
    FROM {{ source('power_center', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC
FROM source_data
WHERE REC_EXCP_IND = 'DD_UPDATE'