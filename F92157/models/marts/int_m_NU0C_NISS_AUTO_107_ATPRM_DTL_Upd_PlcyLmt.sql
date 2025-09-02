{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  -- Placeholder for source data. Replace with actual source table reference.
  SELECT
    "NISS_APRM_DETL_SK",
    "NISS_PLCY_LMT_CD"
  FROM { source('source_system', 'table_name') }
),

-- Node: UPD_NISS_PLCY_LMT_CD
upd_niss_plcy_lmt_cd_step AS (
  SELECT
    *,
    -- Update Strategy logic for DD_UPDATE
    CASE
      WHEN "NISS_PLCY_LMT_CD" IS NOT NULL THEN "NISS_PLCY_LMT_CD"
      ELSE NULL
    END AS "NISS_PLCY_LMT_CD"
  FROM source_data
),

final AS (
  SELECT
    "NISS_APRM_DETL_SK",
    "NISS_PLCY_LMT_CD"
  FROM upd_niss_plcy_lmt_cd_step
)

SELECT * FROM final;