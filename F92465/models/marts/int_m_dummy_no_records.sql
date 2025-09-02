{{ config(materialized='ephemeral') }}

WITH source_dim_ag_trans_typ_plcy AS (
  SELECT 
    TRANS_TYP_PLCY_SK,
    TRANS_TYP_PLCY_CD,
    TRANS_TYP_PLCY_DESC,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM {{ source('GENAI_POWER_BI', 'DIM_AG_TRANS_TYP_PLCY') }}
),

source_fdr_lib_dim_ag_trans_typ_plcy AS (
  SELECT 
    TRANS_TYP_PLCY_SK
  FROM {{ source('GENAI_POWER_BI', 'DIM_AG_TRANS_TYP_PLCY') }}
  WHERE 1=0
  -- Dummy SQL to read NO records, instead send a success email in post session
),

exptrans AS (
  SELECT 
    TRANS_TYP_PLCY_SK
  FROM source_dim_ag_trans_typ_plcy
)

SELECT 
  TRANS_TYP_PLCY_SK
FROM exptrans