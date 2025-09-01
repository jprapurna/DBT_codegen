{{
  config(materialized='ephemeral')
}}

WITH seqtrans AS (
  SELECT
    NEXTVAL AS NEXTVAL,
    CURRVAL AS CURRVAL
  FROM { source('genai_power_bi', 'WRK_BIRP_TA_NISS_NU0C_APRM_LND') }
),

exp_pass_through AS (
  SELECT
    REG_PER_YR,
    FISC_PER_YR,
    NAIC_CMPNY_CD,
    ST_NM,
    ST_CD,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    BI_LMT,
    GA_ADDED_AT_FAULT_IND
  FROM seqtrans
),

exptrans AS (
  SELECT
    DECODE(1, 
      ISNULL(i_GRGNG_ZIP), '00000', 
      IS_SPACES(i_GRGNG_ZIP), '00000', 
      LTRIM(RTRIM(i_GRGNG_ZIP)) = '0', '00000', 
      LTRIM(RTRIM(i_GRGNG_ZIP))
    ) AS GRGNG_ZIP_5,
    CASE 
      WHEN ST_CD = '#' THEN '00'
      ELSE ST_CD
    END AS v_FARMERS_STATE_CD,
    CAST(v_FARMERS_STATE_CD AS INTEGER) AS IFARMERS_STATE_CD
  FROM exp_pass_through
),

lkp_ff_ref_niss_state_cd AS (
  SELECT
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM { source('flat_file', '$LookupFile_ff_NISS_STATE') }
  WHERE FARMERS_STATE_NAME = i_ST_NM
),

exptrans1 AS (
  SELECT
    CASE 
      WHEN i_GA_ADDED_AT_FAULT_IND = '1' THEN 'Y'
      ELSE 'N'
    END AS GA_ADDED_AT_FAULT_IND,
    DECODE(1, 
      ISNULL(i_ST_ABBR), '?', 
      IS_SPACES(i_ST_ABBR), '?', 
      LTRIM(RTRIM(i_ST_ABBR))
    ) AS ST_ABBR,
    CASE 
      WHEN ISNULL(i_NISS_STATE_CODE) OR IS_SPACES(i_NISS_STATE_CODE) THEN '?'
      ELSE i_NISS_STATE_CODE
    END AS NISS_STATE_CODE
  FROM exptrans
),

lkp_fdr_lib_ref_tfarmers_state AS (
  SELECT DISTINCT
    R.FARMERS_STATE_CD AS FARMERS_STATE_CD,
    R.STATE_CODE AS STATE_CODE
  FROM { source('genai_power_bi', 'FDR.REF_TFARMERS_STATE') } R
  WHERE R.END_EFF_DT = '2999-12-31'
  ORDER BY FARMERS_STATE_CD
),

exptrans2 AS (
  SELECT
    SUBSTRING(LTRIM(RTRIM(ACCTNG_LOB)), 1, 3) AS o_ANNUAL_STMT_LOB,
    '$PMMappingName' AS MAPPING_NAME,
    '$PMFolderName' AS FOLDER_NAME,
    '$PMWorkflowName' AS WORKFLOW_NAME,
    DECODE(1, 
      ISNULL(i_NISS_TERR_CD), '?', 
      IS_SPACES(i_NISS_TERR_CD), '?', 
      LTRIM(RTRIM(i_NISS_TERR_CD))
    ) AS NISS_TERR_CD
  FROM exptrans1
),

lkp_fdr_lib_rbi_ref_auto_terr_bystziplob AS (
  SELECT
    REF.REF_AUTO_TERR_SK AS REF_AUTO_TERR_SK,
    REF.END_EFF_DT AS END_EFF_DT,
    REF.NISS_TERR_CD AS NISS_TERR_CD,
    REF.CNTY_NM AS CNTY_NM,
    REF.CITY_NM AS CITY_NM
  FROM { source('genai_power_bi', 'BIRP.RBI_REF_AUTO_TERR') } REF
  WHERE REF.END_EFF_DT = '2999-12-31'
  ORDER BY NISS_ST_CD, ST_ABBRV, ZIP_CD, PP_COMMRCL_CD
),

final AS (
  SELECT
    *,
    { mplt_abc_mapping_audit(MAPPING_NAME, FOLDER_NAME, WORKFLOW_NAME) }
  FROM exptrans2
)

SELECT * FROM final