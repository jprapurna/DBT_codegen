{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    POLICY_STATE,
    BUR,
    SOURCE_NAME,
    {{ macro_isnull('BUR') }} AS BUR_CLEANED
  FROM source_data
)

SELECT * FROM exp_bur;