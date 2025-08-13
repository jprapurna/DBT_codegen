-- Purpose: Reporting and analytics on auto territory details.
SELECT 
  {{ dbt_utils.surrogate_key(['NISS_TERR_CD', 'CNTY_NM', 'CITY_NM']) }} AS territory_key,
  NISS_TERR_CD,
  CNTY_NM,
  CITY_NM
FROM {{ ref('int_auto_territory_lookup') }}

#### schema.yml
version: 2

models:
  - name: int_auto_territory_lookup
    columns:
      - name: REF_AUTO_TERR_SK
        tests:
          - not_null
          - unique
      - name: NISS_TERR_CD
        tests:
          - not_null
      - name: CNTY_NM
        tests:
          - not_null
      - name: CITY_NM
        tests:
          - not_null

  - name: int_niss_auto_aprm_dtl_load
    columns:
      - name: NISS_PASSV_RESTRA_CD
        tests:
          - not_null
      - name: NISS_DEFNS_DRVR_CRD_CD
        tests:
          - not_null

  - name: fct_auto_territory_details
    columns:
      - name: territory_key
        tests:
          - not_null
          - unique
      - name: NISS_TERR_CD
        tests:
          - not_null
      - name: CNTY_NM
        tests:
          - not_null
      - name: CITY_NM
        tests:
          - not_null

seeds:
  - name: auto_territory_reference
    columns:
      - name: NISS_ST_CD
        tests:
          - not_null
          - unique
      - name: ST_ABBRV
        tests:
          - not_null
      - name: ZIP_CD
        tests:
          - not_null
      - name: PP_COMMRCL_CD
        tests:
          - not_null