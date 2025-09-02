{{
  config(
    materialized='ephemeral'
  )
}}

WITH source_data AS (
  -- Placeholder for source data extraction
  SELECT
    -- Input fields
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC
  FROM { source('source_system', 'table_name') }
),

-- Node: UPD_NISS_CLASS_CD
upd_niss_class_cd_step AS (
  SELECT
    *,
    -- Update Strategy transformation logic
    CASE
      WHEN DD_UPDATE THEN 'DD_UPDATE'
      ELSE NULL
    END AS update_strategy_flag
  FROM source_data
),

final AS (
  SELECT
    -- Final field selection
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC
  FROM upd_niss_class_cd_step
)

SELECT * FROM final;