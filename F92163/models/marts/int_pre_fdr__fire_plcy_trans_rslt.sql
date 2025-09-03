{{
  config(
    materialized='ephemeral'
  )
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('DBA_COMMON_UTILS', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}
),

lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT AS (
  SELECT
    PLCY_ID_SK,
    MIN(EFF_DT) AS EFF_DT
  FROM source_data
  GROUP BY PLCY_ID_SK
),

exp_DATE_LOGIC AS (
  SELECT
    PLCY_ID_SK,
    EFF_DT
  FROM lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT
)

SELECT * FROM exp_DATE_LOGIC