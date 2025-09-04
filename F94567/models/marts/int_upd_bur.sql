{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_rtr_clm_insert_upd') }}
),

upd_bur AS (
  SELECT 
    BATCH_ID AS BATCH_ID1,
    o_Flag AS o_Flag1
  FROM source_data
  WHERE o_Flag = 'U'
),

final AS (
  SELECT *
  FROM upd_bur
)

SELECT * FROM final