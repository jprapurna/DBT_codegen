{{
  config(materialized='ephemeral')
}}

WITH router_insert_update AS (
  SELECT *
  FROM {{ ref('int_cdm__exp_flag') }}
  WHERE o_flag IN ('I', 'U')
)

SELECT *
FROM router_insert_update