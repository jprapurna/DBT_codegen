-- Purpose: This model represents the final output for reporting or analytics, containing updated class codes and exception handling.

SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCP_DESC,
    CURRENT_TIMESTAMP() AS CDM_INSERT_DT
FROM {{ ref('int_UPD_NISS_CLASS_CD') }}