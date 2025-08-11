-- Purpose: This model serves as the final output for reporting or analytics.

SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCP_DESC,
    CURRENT_TIMESTAMP() AS cdm_insert_dt
FROM
    {{ ref('int_upd_niss_class_cd') }}