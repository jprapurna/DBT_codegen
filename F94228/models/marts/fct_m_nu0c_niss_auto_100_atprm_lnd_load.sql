{{ config(materialized='table') }}

SELECT
  niss_atprm_lnd_sk,
  reg_per_yr,
  fisc_per_yr,
  niss_terr_cd,
  state_abbr,
  ga_umbi_pd_added_ind,
  o_niss_cmpny_cd
FROM {{ ref('int_m_nu0c_niss_auto_100_atprm_lnd_load') }}