-- Purpose: Represents the expression transformation logic for various fields

WITH expression_transformation AS (
  SELECT 
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ST_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    RT_CLS,
    AGE,
    GENDR,
    MRTL_STAT,
    IIF(ISNULL(I_AUTO_USE_CD),'',I_AUTO_USE_CD) AS AUTO_USE_CD,
    TO_INTEGER(AGE) AS IAGE,
    TO_INTEGER(MILES_TO_WRK) AS IMILES_TO_WRK,
    GOOD_STDNT_IND,
    DRVR_TRNG_IND,
    SOI_TYP,
    ACCTNG_LOB,
    CVG_TYP_CD,
    NISS_CLASS_CD_FL,
    DECODE(ST_ABBR, 'NY', 'NY_Class', 'NJ', 'NJ_Class', 'Other_Class') AS v_CLASS_CD_Indemnity,
    IIF(ST_ABBR = 'FL', NISS_CLASS_CD_FL, '') AS v_CLASS_CD_Auto_1A,
    IIF(ST_ABBR IN ('MI', 'MT'), 'Special_Class', 'Regular_Class') AS v_CLASS_CD_Auto_4,
    DECODE(ST_ABBR, 'LA', 'LA_Class', 'Other_State_Class') AS v_CLASS_CD_Auto_5,
    DECODE(ST_ABBR, 'PA', 'PA_Class', 'Other_State_Class') AS v_CLASS_CD_Auto_6
  FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  NISS_APRM_DETL_SK,
  ST_ABBR,
  ST_CD,
  RATNG_CMPY_CD,
  MLT_CAR_IND,
  RT_CLS,
  IAGE,
  GENDR,
  MRTL_STAT,
  AUTO_USE_CD,
  IMILES_TO_WRK,
  GOOD_STDNT_IND,
  DRVR_TRNG_IND,
  SOI_TYP,
  ACCTNG_LOB,
  CVG_TYP_CD,
  NISS_CLASS_CD_FL,
  v_CLASS_CD_Indemnity,
  v_CLASS_CD_Auto_1A,
  v_CLASS_CD_Auto_4,
  v_CLASS_CD_Auto_5,
  v_CLASS_CD_Auto_6
FROM expression_transformation