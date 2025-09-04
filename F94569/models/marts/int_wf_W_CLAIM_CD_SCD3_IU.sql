{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('SQ_CDH_GW_BUR', 'SQ_CDH_GW_BUR') }}
),

-- Node: Lookup Claim Code
lookup_claim_code AS (
  SELECT
    source_data.*,
    lkp_claim_code.claim_code AS claim_code
  FROM source_data
  LEFT JOIN {{ source('LKP_W_CLAIM_CD_BUR_SCD3', 'LKP_W_CLAIM_CD_BUR_SCD3') }} AS lkp_claim_code
  ON source_data.claim_id = lkp_claim_code.claim_id
),

-- Node: Batch Control ID Lookup
batch_control_id_lookup AS (
  SELECT
    lookup_claim_code.*,
    lkp_batch_ctrl.batch_ctrl_id AS batch_ctrl_id
  FROM lookup_claim_code
  LEFT JOIN {{ source('lkp_CDM_BATCH_CTRLID', 'lkp_CDM_BATCH_CTRLID') }} AS lkp_batch_ctrl
  ON lookup_claim_code.batch_id = lkp_batch_ctrl.batch_id
),

-- Node: Max Row ID Lookup
max_row_id_lookup AS (
  SELECT
    batch_control_id_lookup.*,
    lkp_max_row.row_id AS max_row_id
  FROM batch_control_id_lookup
  LEFT JOIN {{ source('lkp_MAX_ROW_WID', 'lkp_MAX_ROW_WID') }} AS lkp_max_row
  ON batch_control_id_lookup.row_id = lkp_max_row.row_id
),

final AS (
  SELECT
    *,
    -- Example transformation logic
    CASE 
      WHEN max_row_id_lookup.claim_code IS NULL THEN 'Unknown'
      ELSE max_row_id_lookup.claim_code
    END AS transformed_claim_code
  FROM max_row_id_lookup
)

SELECT * FROM final;