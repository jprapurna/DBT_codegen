{{
  config(materialized='ephemeral')
}}

WITH insert_data AS (
  SELECT
    *
  FROM {{ ref('int_cdm_router__clm_insert_upd') }}
  WHERE o_Flag = 'I'
)

SELECT * FROM insert_data