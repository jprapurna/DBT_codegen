{{
  config(materialized='ephemeral')
}}

WITH exp_row_wid AS (
  SELECT 
    {{ macro_increment_v1('V1') }} AS V2,
    CASE 
      WHEN V2 = 0 THEN {{ macro_lkp_max_row_wid('TGT_TABLE_NAME') }}
      ELSE V2
    END AS ROW_WID
  FROM {{ source('custom_table') }}
)

SELECT ROW_WID
FROM exp_row_wid