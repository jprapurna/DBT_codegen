{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('source_system', 'table_name') }}
),

-- Node: UPD_NISS_CLASS_CD
UPD_NISS_CLASS_CD_step AS (
  SELECT
    *,
    -- Update Strategy logic
    CASE 
      WHEN DD_UPDATE THEN 'Update'
      ELSE 'No Update'
    END AS update_status
  FROM source_data
),

-- Node: EXP_To_Drv_Class_Cd1
EXP_To_Drv_Class_Cd1_step AS (
  SELECT *
  FROM {{ mplt_EXP_To_Drv_Class_Cd1(
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ST_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    RT_CLS,
    AGE,
    GENDR,
    MRTL_STAT,
    I_AUTO_USE_CD,
    AUTO_USE_CD,
    MILES_TO_WRK,
    GOOD_STDNT_IND,
    DRVR_TRNG_IND,
    SOI_TYP,
    ACCTNG_LOB,
    IAGE,
    IMILES_TO_WRK,
    CVG_TYP_CD,
    NISS_CLASS_CD_FL,
    v_CLASS_CD_Indemnity,
    v_CLASS_CD_Auto_1,
    v_CLASS_CD_Auto_1A,
    v_CLASS_CD_Auto_2,
    v_CLASS_CD_Auto_3,
    v_CLASS_CD_Auto_4,
    v_CLASS_CD_Auto_5,
    v_CLASS_CD_Auto_6
  ) }}
),

final AS (
  SELECT *
  FROM EXP_To_Drv_Class_Cd1_step
)

SELECT *
FROM final