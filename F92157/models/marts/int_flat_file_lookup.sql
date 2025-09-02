{{ config(materialized='table') }}

SELECT
  i_ST_NM AS i_st_nm,
  FARMERS_STATE_NAME AS farmers_state_name,
  NISS_STATE_CODE AS niss_state_code
FROM {{ source('flat_file', 'lookup_file_ff_niss_state') }}