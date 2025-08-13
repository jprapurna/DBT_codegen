-- Purpose: Reporting on written premium at coverage level
WITH premium_data AS (
    SELECT
        {{ dbt_utils.surrogate_key(['PLCY_CNTRCT_NUM']) }} AS policy_key,
        territory.NISS_TERR_CD,
        territory.NISS_ST_CD,
        territory.ST_ABBRV,
        territory.ZIP_CD,
        coverage.TTL_WRITTN_PREM_AMT,
        coverage.CVG_EXPS_VAL
    FROM {{ ref('int_auto_territory') }} AS territory
    JOIN {{ source('power_center', 'WRK_BIRP_NISS_APRM_DETL') }} AS coverage
    ON territory.NISS_TERR_CD = coverage.NISS_TERR_CD
)

SELECT * FROM premium_data

#### schema.yml
version: 2

models:
  - name: fct_written_premium
    description: Reporting on written premium at coverage level
    columns:
      - name: policy_key
        description: Surrogate key for policy contract number
        tests:
          - not_null
          - unique
      - name: TTL_WRITTN_PREM_AMT
        description: Total written premium amount
        tests:
          - not_null
      - name: CVG_EXPS_VAL
        description: Coverage expense value
        tests:
          - not_null

seeds:
  - name: farmers_state
    description: Encodes state codes for Farmers
    columns:
      - name: FARMERS_STATE_CD
        description: Farmers state code
        tests:
          - not_null
          - unique
      - name: STATE_CODE
        description: State code
        tests:
          - not_null
          - unique