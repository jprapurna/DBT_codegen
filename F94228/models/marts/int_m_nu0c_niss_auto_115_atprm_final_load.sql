{{ config(materialized='ephemeral') }}

WITH exp_passthru AS (
  SELECT
    CLNDR_YR,
    CALL_YR,
    NISS_CMPNY_CD,
    ST_NM,
    ST_CD,
    '{{ var("PMMappingName") }}' AS MAAPING_NAME,
    '{{ var("PMFolderName") }}' AS FOLDER_NAME,
    '{{ var("PMWorkflowName") }}' AS WORKFLOW_NAME
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),
exp_passthru_tgt AS (
  SELECT
    CVG_ATTR_SK,
    CVG_ATTR_SK AS NISS_APRM_FINAL_SK,
    CLNDR_YR,
    CALL_YR,
    NISS_CMPNY_CD,
    ST_NM,
    ST_CD,
    ST_ABBR,
    NISS_ST_CD,
    LINE_CD
  FROM exp_passthru
),
abc_mapping_audit AS (
  SELECT *
  FROM {{ mplt_fdr_lib_abc_mapping_audit('PMMappingName', 'PMFolderName', 'PMWorkflowName') }}
)
SELECT *
FROM exp_passthru_tgt