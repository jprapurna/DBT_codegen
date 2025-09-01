{{ config(materialized='ephemeral') }}

WITH max_row_wid AS (
  SELECT * FROM {{ ref('int_cdm__max_row_wid') }}
),

exp_row_wid AS (
  SELECT
    ROW_WID,
    TABLE_NAME,
    {{ macro_row_wid_logic('ROW_WID') }} AS incremented_row_wid
  FROM max_row_wid
)

SELECT * FROM exp_row_wid