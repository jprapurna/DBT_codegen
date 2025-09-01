{{
  config(
    materialized='ephemeral'
  )
}}

WITH EXP_DeriveBalanaceIndicator AS (
  SELECT
    CLNDR_YR, -- Input field passed through without transformation
    SUBSTRING(TRIM(CLNDR_YR), 3, 2) AS o_CLNDR_YR, -- Extract last two digits of calendar year
    NISS_CMPNY_CD, -- Company code passed through without transformation
    ST_NM, -- State name passed through without transformation
    DET_PREM_AMT, -- Detailed premium amount passed through without transformation
    DROP_PREM_AMT, -- Dropped premium amount passed through without transformation
    FNL_PREM_AMT, -- Final premium amount passed through without transformation
    DET_PREM_AMT - DROP_PREM_AMT - FNL_PREM_AMT AS v_BAL_DIFF, -- Calculate balance difference
    CASE 
      WHEN DET_PREM_AMT - DROP_PREM_AMT - FNL_PREM_AMT = 0 THEN 'Y'
      ELSE 'N'
    END AS BAL_IND, -- Derive balance indicator
    DET_PREM_AMT - DROP_PREM_AMT - FNL_PREM_AMT AS BAL_DIFF -- Output balance difference
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT *
FROM EXP_DeriveBalanaceIndicator;