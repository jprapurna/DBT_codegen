{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('GENAI_POWER_BI', 'SQ_CDH_GW_BUR') }}
),

exp_ROW_WID AS (
  SELECT 
    *,
    CASE 
      WHEN v2 = 0 THEN {{ mplt_lkp_max_row_wid('TGT_TABLE_NAME') }}
      ELSE v2
    END AS ROW_WID
  FROM source_data
),

exp_INCREMENT_V1 AS (
  SELECT 
    *,
    v1 + 1 AS V2
  FROM exp_ROW_WID
),

rtr_CLM_INSERT_UPD AS (
  SELECT 
    *,
    {{ mplt_flag_logic('o_Flag') }}
  FROM exp_INCREMENT_V1
)

SELECT * 
FROM rtr_CLM_INSERT_UPD