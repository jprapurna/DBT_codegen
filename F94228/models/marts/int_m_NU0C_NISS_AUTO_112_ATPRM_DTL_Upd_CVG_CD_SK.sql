{{
  config(
    materialized='ephemeral'
  )
}}

WITH EXP_To_generate_CVG_CD_SK AS (
  -- Node: EXP_To_generate_CVG_CD_SK
  -- Description: Expression transformation to generate the coverage code surrogate key
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK,
    CVG_CD_ATTR_SK
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

Upd_CVG_CD_SK AS (
  -- Node: Upd_CVG_CD_SK
  -- Description: Update Strategy transformation to update coverage code surrogate key
  SELECT
    NISS_APRM_DETL_SK,
    CVG_CD_ATTR_SK,
    CASE
      WHEN DD_UPDATE THEN 'DD_UPDATE'
      ELSE NULL
    END AS update_strategy
  FROM EXP_To_generate_CVG_CD_SK
)

SELECT *
FROM Upd_CVG_CD_SK;