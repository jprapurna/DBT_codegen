WITH base_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME,
    {{ ref('stg_cdm_batch_ctrlid') }}.BATCH_ID
  FROM {{ ref('stg_cdh_gw_bur') }}
  LEFT JOIN {{ ref('stg_cdm_batch_ctrlid') }}
  ON {{ ref('stg_cdh_gw_bur') }}.SOURCE_NAME = {{ ref('stg_cdm_batch_ctrlid') }}.SOURCE_NAME
),
lookup_data AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID,
    INTEGRATION_ID AS LKP_INTEGRATION_ID,
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('genai_power_bi', 'w_claim_cd_bur_scd3') }}
),
flagged_data AS (
  SELECT 
    base_data.*,
    lookup_data.LKP_ROW_WID,
    lookup_data.LKP_INTEGRATION_ID,
    lookup_data.LKP_NEW_BUR,
    CASE
      WHEN lookup_data.LKP_ROW_WID IS NULL THEN 'I'
      ELSE {{ md5_compare('base_data.BUR', 'lookup_data.LKP_NEW_BUR') }}
    END AS FLAG
  FROM base_data
  LEFT JOIN lookup_data
  ON base_data.INTEGRATION_ID = lookup_data.LKP_INTEGRATION_ID
)
SELECT * FROM flagged_data