{{
  config(materialized='ephemeral')
}}

WITH update_data AS (
  SELECT
    *
  FROM {{ ref('int_cdm_router__clm_insert_upd') }}
  WHERE o_Flag = 'U'
)

SELECT * FROM update_data