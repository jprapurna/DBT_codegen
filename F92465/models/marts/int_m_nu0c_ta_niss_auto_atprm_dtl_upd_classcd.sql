{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT
    *,
    NISS_APRM_DETL_SK,
    TRIM(ST_CD) AS ST_CD,
    TRIM(ST_ABBR) AS ST_ABBR,
    TRIM(ACCTNG_LOB) AS ACCTNG_LOB,
    TRIM(CVG_TYP_CD) AS CVG_TYP_CD,
    TRIM(RATNG_CMPY_CD) AS RATNG_CMPY_CD,
    TRIM(MLT_CAR_IND) AS MLT_CAR_IND,
    TRIM(FINAL_RDRVR_AGE) AS FINAL_RDRVR_AGE,
    TRIM(GENDR) AS GENDR,
    TRIM(MRTL_STAT) AS MRTL_STAT,
    TRIM(AUTO_USE_CD) AS AUTO_USE_CD,
    TRIM(SOI_TYP) AS SOI_TYP,
    NISS_CLASS_CD,
    REC_DROP_IND,
    REC_DROP_RSN_DESC,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC,
    TRIM(PRINCIPAL_OPRT) AS PRINCIPAL_OPRT,
    SOURCE_IND_DERIVED
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR NOT IN ('NY', 'NJ') AND SOURCE_IND_DERIVED = 'TOGGLE AUTO'
),

-- Node: EXP_PASS_THROUGH
exp_pass_through AS (
  SELECT
    *
  FROM source_data
),

-- Node: EXP_DERV_CLASS_CD
exp_derv_class_cd AS (
  SELECT
    *,
    CASE
      WHEN CVG_TYP_CD = 'AUTO' AND MLT_CAR_IND = 'Y' THEN 'CLASS_A'
      WHEN CVG_TYP_CD = 'AUTO' AND MLT_CAR_IND = 'N' THEN 'CLASS_B'
      WHEN CVG_TYP_CD = 'HOME' THEN 'CLASS_H'
      ELSE 'CLASS_UNKNOWN'
    END AS derived_class_cd
  FROM exp_pass_through
),

-- Node: UPD_NISS_CLASS_CD
upd_niss_class_cd AS (
  SELECT
    *,
    CASE
      WHEN derived_class_cd = 'CLASS_A' THEN 'DD_UPDATE'
      WHEN derived_class_cd = 'CLASS_B' THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_derv_class_cd
)

SELECT *
FROM upd_niss_class_cd