{{ config(materialized='table') }}

SELECT 
  NISS_APRM_DETL_SK,
  NISS_CLASS_CD,
  REC_EXCP_IND,
  REC_EXCP_DESC
FROM {{ ref('int_m_NU0C_NISS_AUTO_104_ATPRM_DTL_Upd_NYNJClassCd') }};