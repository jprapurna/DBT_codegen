{{ config(materialized='ephemeral') }}

WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    TABLE_NAME
  FROM {{ source('cdm', 'custom_table') }}
  WHERE TABLE_NAME = 'W_CLAIM_CD_BUR_SCD3'
)

SELECT * FROM max_row_wid