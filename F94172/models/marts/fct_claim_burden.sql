{{ config(materialized='table') }}
WITH flag_data AS (
    SELECT
        INTEGRATION_ID,
        SOURCE_NAME,
        CASE
            WHEN LKP_ROW_WID IS NULL THEN 'I'
            WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
            ELSE 'U'
        END AS o_Flag,
        SYSDATE AS CDM_INSERT_DT,
        SYSDATE AS CDM_UPDATE_DT,
        'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
    FROM {{ ref('stg_cdh_gw_bur') }}
    LEFT JOIN {{ ref('stg_claim_burden') }}
    ON INTEGRATION_ID = lkp_INTEGRATION_ID
)
SELECT * FROM flag_data;

#### schema.yml
-- Purpose: Schema definitions for sources and models.
version: 2
sources:
  - name: CDH_GW_BUR
    tables:
      - name: CDH_GW_BUR
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
  - name: W_CLAIM_CD_BUR_SCD3
    tables:
      - name: W_CLAIM_CD_BUR_SCD3
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
  - name: CDM_BATCH_CTRLID
    tables:
      - name: CDM_BATCH_CTRLID
        columns:
          - name: BATCH_ID
            tests:
              - not_null
          - name: SOURCE_NAME
            tests:
              - not_null
  - name: CDM_ROW_WID_MAX
    tables:
      - name: CDM_ROW_WID_MAX
        columns:
          - name: ROW_WID
            tests:
              - not_null
          - name: TABLE_NAME
            tests:
              - not_null

models:
  - name: stg_cdh_gw_bur
    tests:
      - unique:
          column_name: POLICY_STATE
  - name: stg_claim_burden
    tests:
      - unique:
          column_name: ROW_WID
  - name: int_batch_control
    tests:
      - not_null:
          column_name: BATCH_ID
  - name: int_max_row_wid
    tests:
      - not_null:
          column_name: ROW_WID
  - name: fct_claim_burden
    tests:
      - not_null:
          column_name: INTEGRATION_ID