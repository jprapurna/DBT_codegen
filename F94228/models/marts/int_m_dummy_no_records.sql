{{
  config(materialized='ephemeral')
}}

WITH EXPTRANS AS (
  -- Node: EXPTRANS
  -- Description: Expression transformation named EXPTRANS in mapping m_DummyNoRecords. It processes the field TRANS_TYP_PLCY_SK with the expression TRANS_TYP_PLCY_SK.
  SELECT
    TRANS_TYP_PLCY_SK
  FROM {{ source('genai_power_bi', 'DIM_AG_TRANS_TYP_PLCY') }}
)

SELECT *
FROM EXPTRANS;