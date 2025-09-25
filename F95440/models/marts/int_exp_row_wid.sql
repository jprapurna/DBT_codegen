{{
  config(materialized='ephemeral')
}}

WITH claim_cd_bur_data AS (
  SELECT * FROM {{ ref('int_w_claim_cd_bur_scd3') }}
),

exp_row_wid AS (
  SELECT
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    NEW_BUR_CLEANED,
    ROW_NUMBER() OVER (PARTITION BY LKP_INTEGRATION_ID ORDER BY LKP_ROW_WID) AS ROW_WID
  FROM claim_cd_bur_data
)

SELECT * FROM exp_row_wid;