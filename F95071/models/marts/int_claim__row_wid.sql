{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_claim__batch_id') }}
),

lookup_step AS (
  SELECT
    ROW_WID,
    TABLE_NAME
  FROM {{ ref('int_claim__row_wid') }}
  WHERE TABLE_NAME = 'TGT_TABLE_NAME'
),

row_wid_step AS (
  SELECT
    *,
    CASE 
      WHEN v2 = 0 THEN {{ macro_max_row_wid('TGT_TABLE_NAME') }}
      ELSE v2
    END AS ROW_WID
  FROM source_data
)

SELECT *
FROM row_wid_step