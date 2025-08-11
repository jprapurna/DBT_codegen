-- Purpose: This model represents the final output for reporting or analytics, containing updated class codes and exception handling.

SELECT
  NISS_APRM_DETL_SK,
  niss_class_cd,
  rec_excpn_ind,
  rec_excp_desc,
  CURRENT_TIMESTAMP() AS cdm_insert_dt
FROM
  {{ ref('int_upd_niss_class_cd') }}