{{
  config(materialized='ephemeral')
}}

WITH EXP_PassThrough AS (
  -- Node: EXP_PassThrough
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

EXPTRANS AS (
  -- Node: EXPTRANS
  SELECT
    CVG_ATTR_CHCKSUM,
    v_CVG_ATTR_SK + 1 AS v_CVG_ATTR_SK,
    v_CVG_ATTR_SK AS CVG_ATTR_SK
  FROM EXP_PassThrough
),

EXPTRANS1 AS (
  -- Node: EXPTRANS1
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR_CHCKSUM
  FROM EXP_PassThrough
),

JNRTRANS AS (
  -- Node: JNRTRANS
  SELECT
    master.NISS_APRM_DETL_SK,
    master.CVG_ATTR_CHCKSUM AS CVG_ATTR_CHCKSUM,
    detail.CVG_ATTR_CHCKSUM AS CVG_ATTR_CHCKSUM1,
    master.CVG_ATTR_SK
  FROM EXPTRANS master
  JOIN EXPTRANS1 detail
    ON master.CVG_ATTR_CHCKSUM = detail.CVG_ATTR_CHCKSUM
),

Upd_CVG_ATTR_SK AS (
  -- Node: Upd_CVG_ATTR_SK
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM JNRTRANS
  WHERE 'DD_UPDATE' = 'DD_UPDATE' -- Update Strategy logic
)

SELECT *
FROM Upd_CVG_ATTR_SK;