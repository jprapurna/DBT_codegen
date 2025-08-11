-- Purpose: This model applies update strategy to the derived class codes and handles record exceptions.

WITH updated_class_codes AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCPN_IND,
        REC_EXCP_DESC
    FROM {{ ref('int_EXP_DERV_CLASS_CD') }}
)

SELECT * FROM updated_class_codes