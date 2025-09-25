{{
  config(materialized='ephemeral')
}}

WITH cdh_gw_bur_data AS (
  SELECT * FROM {{ ref('int_cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    POLICY_STATE,
    BUR_CLEANED,
    SOURCE_NAME,
    {{ macro_current_date() }} AS PROCESS_DATE
  FROM cdh_gw_bur_data
)

SELECT * FROM exp_bur;