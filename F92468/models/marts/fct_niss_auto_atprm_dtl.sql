-- Purpose: This model serves as the final output for reporting or analytics, representing the NISS Auto ATPRM Detail.

SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCP_DESC
FROM {{ ref('int_upd_niss_class_cd') }}