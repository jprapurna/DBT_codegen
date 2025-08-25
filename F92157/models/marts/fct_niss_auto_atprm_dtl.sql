{{ config(materialized='table') }}

SELECT
    -- NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC
FROM {{ ref('int_niss_auto_atprm_dtl') }}