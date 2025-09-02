{{
  config(materialized='ephemeral')
}}

WITH EXP_DERV_CLASS_CD AS (
  -- Node: EXP_DERV_CLASS_CD
  -- Purpose: Derive class codes based on state abbreviations, age, gender, marital status, and other factors
  SELECT
    NISS_APRM_DETL_SK,
    ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    AGE,
    -- Example transformation logic for derived fields
    CASE 
      WHEN AGE < 25 THEN 'Young'
      ELSE 'Adult'
    END AS IAGE,
    GENDR,
    MRTL_STAT,
    i_AUTO_USE_CD AS AUTO_USE_CD,
    SOI_TYP,
    -- Derived class codes
    CASE 
      WHEN ST_ABBR = 'NJ' THEN 'Class_NJ'
      WHEN ST_ABBR = 'FL' THEN 'Class_FL'
      ELSE 'Class_Default'
    END AS v_CLASS_CD_Indemnity,
    CASE 
      WHEN MLT_CAR_IND = 'Y' THEN 'MultiCar'
      ELSE 'SingleCar'
    END AS v_CLASS_CODE_TAuto,
    -- Final class code derivation
    CASE 
      WHEN v_CLASS_CODE_TAuto = 'MultiCar' THEN 'MultiCar_Final'
      ELSE v_CLASS_CODE_TAuto
    END AS v_CLASS_CODE_TAuto_Final,
    -- Additional derived fields
    v_CLASS_CODE_TAuto_Final AS v_NISS_CLASS_CD,
    v_NISS_CLASS_CD AS NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC_CLASS,
    REC_EXCPN_IND,
    REC_EXCP_DESC
  FROM { source('source_system', 'table_name') }
),

UPD_NISS_CLASS_CD AS (
  -- Node: UPD_NISS_CLASS_CD
  -- Purpose: Update records with DD_UPDATE strategy and forward rejected rows
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCP_DESC,
    -- Update strategy logic
    CASE 
      WHEN REC_EXCPN_IND = 'Y' THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM EXP_DERV_CLASS_CD
)

SELECT *
FROM UPD_NISS_CLASS_CD;