{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('source_name', 'table_name') }}
),

-- Node: EXP_Defaults
exp_defaults_step AS (
  SELECT
    REG_PER_YR,
    FISC_PER_YR,
    NAIC_CMPY_CD,
    ST_NM,
    ST_CD,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    BI_LMT
  FROM source_data
),

-- Node: EXP_Passthru
exp_passthru_step AS (
  SELECT
    *,
    DECODE(1, ISNULL(i_GRGNG_ZIP_5), '00000', IS_SPACES(i_GRGNG_ZIP_5), '00000', LTRIM(RTRIM(i_GRGNG_ZIP_5)) = '0', '00000', LTRIM(RTRIM(i_GRGNG_ZIP_5))) AS GRGNG_ZIP_5
  FROM exp_defaults_step
),

-- Node: LKP_ff_REF_NISS_STATE_CD
lkp_ff_ref_niss_state_cd_step AS (
  SELECT
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM {{ source('schema', 'table') }}
  WHERE FARMERS_STATE_NAME = i_ST_NM
),

-- Node: LKP_FDR_LIB_REF_TFARMERS_STATE
lkp_fdr_lib_ref_tfarmers_state_step AS (
  SELECT
    FARMERS_STATE_CD,
    STATE_CODE
  FROM {{ source('schema', 'table') }}
  WHERE FARMERS_STATE_CD = i_FARMERS_STATE_CD
),

-- Node: EXP_To_Derive_Vals
exp_to_derive_vals_step AS (
  SELECT
    *,
    DECODE(1, ISNULL(i_NISS_TERR_CD), '?', IS_SPACES(i_NISS_TERR_CD), '?', LTRIM(RTRIM(i_NISS_TERR_CD))) AS NISS_TERR_CD
  FROM exp_passthru_step
),

-- Node: EXP_Passtotgt
exp_passtotgt_step AS (
  SELECT
    *,
    v_CNT + 1 AS v_CNT,
    v_CNT AS NISS_ATPRM_LND_SK
  FROM exp_to_derive_vals_step
)

SELECT *
FROM exp_passtotgt_step

---