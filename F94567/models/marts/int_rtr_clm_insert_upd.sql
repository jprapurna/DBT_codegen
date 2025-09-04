{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ ref('int_exp_flag') }}
),

rtr_clm_insert_upd AS (
  SELECT *
  FROM source_data
  WHERE o_Flag IN ('I', 'U')
),

final AS (
  SELECT *
  FROM rtr_clm_insert_upd
)

SELECT * FROM final