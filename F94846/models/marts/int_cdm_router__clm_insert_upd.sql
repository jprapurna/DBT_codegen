{{
  config(materialized='ephemeral')
}}

WITH router_data AS (
  SELECT
    *
  FROM {{ ref('int_cdm_flag__exp_flag') }}
  WHERE o_Flag IN ('I', 'U')
)

SELECT * FROM router_data