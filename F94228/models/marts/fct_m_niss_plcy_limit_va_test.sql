{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  o_NISS_PLCY_LIMIT_CD_VA,
  CVG_AMT,
  v_CVG_AMT,
  v_CVG_AMT_Parts,
  v_CVG_AMT_Part1_Pos,
  v_CVG_AMT_Part2_Pos,
  v_AMOUNT_FIELD1,
  v_AMOUNT_FIELD2,
  v_AMOUNT_FIELD3,
  CVG_AMT_1_String,
  CVG_AMT_2_String,
  CVG_AMT_3_String,
  CVG_AMT_1_Decimal,
  CVG_AMT_2_Decimal,
  CVG_AMT_3_Decimal,
  CVG_AMT_NO_OF_PARTS,
  SRC_CVG_AMT,
  v_NISS_PLCY_LMT_CD
FROM {{ ref('int_m_niss_plcy_limit_va_test') }};