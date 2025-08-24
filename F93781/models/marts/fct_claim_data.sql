-- Purpose: Final model for claim data ready for reporting.
{{ config(materialized='table') }}
select
    ROW_WID,
    INTEGRATION_ID,
    NEW_BUR,
    operation_flag
from {{ ref('int_claim_data_transform') }}
where operation_flag in ('I', 'U')

#### schema.yml
version: 2

sources:
  - name: CDH_GWODS
    description: Source for CDH Gateway ODS data
    database: DBA_COMMON_UTILS
    schema: CDH_GWODS
    tables:
      - name: SQ_CDH_GW_BUR
        description: Source query for CDH Gateway BUR
        identifier: DUMMY_SQ_CDH_GW_BUR
        columns:
          - name: POLICY_STATE
            description: State of the policy
            tests:
              - not_null
              - unique
          - name: BUR
            description: BUR value
            tests:
              - not_null
          - name: SOURCE_NAME
            description: Source name for the data
            tests:
              - not_null

  - name: CDM
    description: Source for Claims Data Mart
    database: DBA_COMMON_UTILS
    schema: CDM
    tables:
      - name: W_CLAIM_CD_BUR_SCD3
        description: Insert operation for W_CLAIM_CD_BUR_SCD3
        identifier: DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3
        columns:
          - name: ROW_WID
            description: Row identifier
            tests:
              - not_null
              - unique
          - name: INTEGRATION_ID
            description: Integration identifier
            tests:
              - not_null
          - name: NEW_BUR
            description: New BUR value
            tests:
              - not_null