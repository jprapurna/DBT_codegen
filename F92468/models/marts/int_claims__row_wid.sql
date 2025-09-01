{{ config(materialized='ephemeral') }}

WITH row_wid_data AS (
  SELECT 
    TGT_TABLE_NAME,
    {{ mplt_CDM_ROW_WID(TGT_TABLE_NAME) }} AS ROW_WID
  FROM {{ ref('int_claims__flag') }}
)
SELECT * FROM row_wid_data