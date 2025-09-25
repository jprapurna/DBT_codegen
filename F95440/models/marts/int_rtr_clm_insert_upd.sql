{{
  config(materialized='ephemeral')
}}

WITH exp_flag_data AS (
  SELECT * FROM {{ ref('int_exp_flag') }}
),

rtr_clm_insert_upd AS (
  SELECT
    POLICY_STATE,
    BUR_CLEANED,
    SOURCE_NAME,
    STATE_FLAG,
    CASE 
      WHEN STATE_FLAG = 'New Jersey' THEN 'INSERT'
      WHEN STATE_FLAG = 'New York' THEN 'UPDATE'
      ELSE 'REJECT'
    END AS ACTION
  FROM exp_flag_data
)

SELECT * FROM rtr_clm_insert_upd;