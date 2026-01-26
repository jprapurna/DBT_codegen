{{
  config(materialized='ephemeral')
}}

WITH row_wid_mapplet AS (
  SELECT 
    {{ mplt_CDM_ROW_WID('TGT_TABLE_NAME') }} AS row_wid
)

SELECT *
FROM row_wid_mapplet