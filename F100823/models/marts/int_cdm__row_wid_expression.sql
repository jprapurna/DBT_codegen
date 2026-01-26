{{
  config(materialized='ephemeral')
}}

WITH row_wid_expression AS (
  SELECT 
    CASE 
      WHEN v2 = 0 THEN {{ mplt_CDM_ROW_WID('TGT_TABLE_NAME') }}
      ELSE v2
    END AS row_wid
  FROM {{ ref('int_cdm__row_wid_mapplet') }}
)

SELECT *
FROM row_wid_expression