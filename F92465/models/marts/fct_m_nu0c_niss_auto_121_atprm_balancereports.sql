{{ config(materialized='table') }}

SELECT 
  CLNDR_YR AS Clndr_Year,
  NISS_CMPNY_CD AS Company_Number,
  ST_NM AS State_Name,
  DET_PREM_AMT AS Detail_Premium_Amount,
  DROP_PREM_AMT AS Detail_Dropped_Premium_Amount,
  FNL_PREM_AMT AS Final_Premium_Amount,
  BAL_DIFF AS Premium_Amount_Difference,
  BAL_IND AS Balance_Indicator
FROM {{ ref('int_m_nu0c_niss_auto_121_atprm_balancereports') }}