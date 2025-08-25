WITH processed_data AS (
  SELECT 
    *,
    CASE
      WHEN FLAG = 'I' THEN SYSDATE()
      ELSE NULL
    END AS INSERT_DATE,
    CASE
      WHEN FLAG = 'U' THEN SYSDATE()
      ELSE NULL
    END AS UPDATE_DATE
  FROM {{ ref('int_claim_data') }}
),
row_id_data AS (
  SELECT 
    *,
    {{ generate_row_id('processed_data') }} AS ROW_ID
  FROM processed_data
)
SELECT * FROM row_id_data

#### schema.yml
version: 2

sources:
  - name: genai_power_bi
    description: Source tables for claims data processing
    database: GENAI_POWER_BI
    schema: SCHEMA_CDH_GWODS
    tables:
      - name: cdh_gw_bur
        description: Source table for policy state and BUR data.
        identifier: CDH_GW_BUR
      - name: cdm_batch_ctrlid
        description: Source table for batch control data.
        identifier: CDM_BATCH_CTRLID
      - name: w_claim_cd_bur_scd3
        description: Source table for SCD3 claim data.
        identifier: W_CLAIM_CD_BUR_SCD3

models:
  - name: stg_cdh_gw_bur
    description: Staging model for CDH_GW_BUR data.
  - name: stg_cdm_batch_ctrlid
    description: Staging model for CDM_BATCH_CTRLID data.
  - name: int_claim_data
    description: Intermediate model for claim data processing.
  - name: fct_claim_data
    description: Final model for claim data processing with SCD3 logic.