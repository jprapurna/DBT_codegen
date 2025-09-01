{{ config(materialized='table') }}

WITH processed_data AS (
  SELECT 
    ROW_WID,
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME
  FROM {{ ref('int_claims__row_wid') }}
)
SELECT * FROM processed_data