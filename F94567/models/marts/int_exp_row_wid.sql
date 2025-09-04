{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('custom_table', 'max_row_wid') }}
),

exp_row_wid AS (
  SELECT 
    CASE 
      WHEN v2 = 0 THEN {{ macro_lkp_max_row_wid(TGT_TABLE_NAME) }}
      ELSE v2
    END AS ROW_WID
  FROM source_data
),

final AS (
  SELECT *
  FROM exp_row_wid
)

SELECT * FROM final