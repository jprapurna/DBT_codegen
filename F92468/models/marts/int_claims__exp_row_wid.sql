{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__mplt_cdm_row_wid') }}
),

exp_row_wid AS (
  SELECT
    *,
    CASE
      WHEN v2 = 0 THEN (SELECT ROW_WID FROM {{ source('custom_table', 'custom_table') }} WHERE TABLE_NAME = tgt_table_name)
      ELSE v2
    END AS row_wid
  FROM source_data
)

SELECT *
FROM exp_row_wid