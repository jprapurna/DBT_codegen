-- Purpose: Final model for claim BUR data with SCD3 logic.
WITH final_data AS (
    SELECT 
        int.POLICY_STATE,
        int.BUR,
        int.SOURCE_NAME,
        int.lkp_ROW_WID,
        int.operation_flag,
        CASE 
            WHEN int.operation_flag = 'I' THEN SYSDATE()
            ELSE NULL
        END AS INSERT_DT,
        CASE 
            WHEN int.operation_flag = 'U' THEN SYSDATE()
            ELSE NULL
        END AS UPDATE_DT
    FROM {{ ref('int_claim_bur') }} int
)
SELECT * FROM final_data;

#### schema.yml
-- Purpose: Schema definitions for sources and models.
version: 2

sources:
  - name: CDH_GWODS
    tables:
      - name: SQ_CDH_GW_BUR
        columns:
          - name: POLICY_STATE
            tests:
              - not_null
              - unique
          - name: BUR
            tests:
              - not_null
          - name: SOURCE_NAME
            tests:
              - not_null

  - name: CDM
    tables:
      - name: LKP_W_CLAIM_CD_BUR_SCD3
        columns:
          - name: ROW_WID
            tests:
              - not_null
              - unique
          - name: INTEGRATION_ID
            tests:
              - not_null
          - name: NEW_BUR
            tests:
              - not_null

models:
  - name: stg_cdh_gw_bur
    tests:
      - unique:
          column_name: POLICY_STATE
  - name: stg_cdm_batch_ctrlid
    tests:
      - not_null:
          column_name: BATCH_ID
  - name: int_claim_bur
    tests:
      - relationships:
          from: POLICY_STATE
          to: BUR
  - name: fct_claim_bur
    tests:
      - not_null:
          column_name: INSERT_DT