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
    IIF(ISNULL(AUTO_USE_CD),'',AUTO_USE_CD) AS AUTO_USE_CD,
    TO_INTEGER(AGE) AS IAGE,
    TO_INTEGER(MILES_TO_WRK) AS IMILES_TO_WRK,
    DECODE(ACCTNG_LOB, 'Indemnity', 'Indemnity_Class', 'Other', 'Other_Class') AS v_CLASS_CD_Indemnity,
    IIF(ACCTNG_LOB = 'Auto' AND CVG_TYP_CD = '1', 'Auto_Class_1', 'Other_Class') AS v_CLASS_CD_Auto_1,
    IIF(ST_ABBR = 'FL', NISS_CLASS_CD_FL, '') AS v_CLASS_CD_Auto_1A,
    IIF(ACCTNG_LOB = 'Auto' AND CVG_TYP_CD = '2', 'Auto_Class_2', 'Other_Class') AS v_CLASS_CD_Auto_2,
    IIF(ACCTNG_LOB = 'Auto' AND CVG_TYP_CD = '3', 'Auto_Class_3', 'Other_Class') AS v_CLASS_CD_Auto_3,
    IIF(ACCTNG_LOB = 'Auto' AND CVG_TYP_CD = '4', 'Auto_Class_4', 'Other_Class') AS v_CLASS_CD_Auto_4,
    DECODE(CVG_TYP_CD, '5', 'Auto_Class_5', 'Other', 'Other_Class') AS v_CLASS_CD_Auto_5,
    DECODE(CVG_TYP_CD, '6', 'Auto_Class_6', 'Other', 'Other_Class') AS v_CLASS_CD_Auto_6
  FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

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
  AUTO_USE_CD,
  IAGE,
  IMILES_TO_WRK,
  v_CLASS_CD_Indemnity,
  v_CLASS_CD_Auto_1,
  v_CLASS_CD_Auto_1A,
  v_CLASS_CD_Auto_2,
  v_CLASS_CD_Auto_3,
  v_CLASS_CD_Auto_4,
  v_CLASS_CD_Auto_5,
  v_CLASS_CD_Auto_6
FROM expression_transformation