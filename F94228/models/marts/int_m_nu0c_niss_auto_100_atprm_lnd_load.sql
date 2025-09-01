{{ config(materialized='ephemeral') }}

WITH exp_passthru AS (
  SELECT
    reg_per_yr,
    fisc_per_yr,
    CASE 
      WHEN i_grgng_zip_5 IS NULL THEN '00000'
      WHEN TRIM(i_grgng_zip_5) = '' THEN '00000'
      WHEN TRIM(i_grgng_zip_5) = '0' THEN '00000'
      ELSE TRIM(i_grgng_zip_5)
    END AS grgng_zip_5,
    CASE 
      WHEN st_cd = '#' THEN '00'
      ELSE st_cd
    END AS v_farmers_state_cd,
    CAST(v_farmers_state_cd AS INTEGER) AS ifarmers_state_cd
  FROM {{ source('genai_power_bi', 'WRK_BIRP_TA_NISS_NU0C_APRM_LND') }}
),
lkp_ff_ref_niss_state_cd AS (
  SELECT
    farmers_state_name,
    niss_state_code
  FROM {{ source('flat_file', 'niss_state') }}
  WHERE farmers_state_name = exp_passthru.v_farmers_state_cd
),
lkp_ref_tfarmers_state AS (
  SELECT
    farmers_state_cd,
    state_code,
    region_cd,
    st_agency_cd,
    eff_dt,
    end_eff_dt,
    cr_by_mapng_id,
    upd_by_mapng_id,
    dw_cr_tmsp,
    dw_upd_tmsp,
    wrk_flow_run_id
  FROM {{ source('fdr', 'ref_tfarmers_state') }}
  WHERE farmers_state_cd = exp_passthru.ifarmers_state_cd
),
exp_to_derive_vals AS (
  SELECT
    reg_per_yr,
    fisc_per_yr,
    CASE 
      WHEN i_state_abbr IS NULL THEN '?'
      WHEN TRIM(i_state_abbr) = '' THEN '?'
      ELSE TRIM(i_state_abbr)
    END AS state_abbr,
    CASE 
      WHEN i_ga_umbi_pd_added_ind = 1 THEN 'y'
      ELSE 'n'
    END AS ga_umbi_pd_added_ind,
    CASE 
      WHEN v_naic_cmpy_cd = '10315' THEN '172'
      WHEN v_naic_cmpy_cd = '10317' THEN '174'
      WHEN v_naic_cmpy_cd = '10318' THEN '173'
      WHEN v_naic_cmpy_cd = '10806' THEN '171'
      WHEN v_naic_cmpy_cd = '10873' THEN '170'
      WHEN v_naic_cmpy_cd = '21598' THEN '177'
      WHEN v_naic_cmpy_cd = '21601' THEN '079'
      WHEN v_naic_cmpy_cd = '21628' THEN '073'
      WHEN v_naic_cmpy_cd = '21636' THEN '178'
      WHEN v_naic_cmpy_cd = '21644' THEN '077'
      WHEN v_naic_cmpy_cd = '21652' THEN '070'
      WHEN v_naic_cmpy_cd = '21660' THEN '175'
      WHEN v_naic_cmpy_cd = '21679' THEN '072'
      WHEN v_naic_cmpy_cd = '21687' THEN '176'
      WHEN v_naic_cmpy_cd = '21695' THEN '179'
      WHEN v_naic_cmpy_cd = '21709' THEN '071'
      WHEN v_naic_cmpy_cd = '24392' THEN '169'
      WHEN v_naic_cmpy_cd = '28673' THEN '180'
      WHEN v_naic_cmpy_cd = '36889' THEN '074'
      ELSE ''
    END AS o_niss_cmpny_cd
  FROM exp_passthru
),
exp_passtotgt AS (
  SELECT
    v_cnt + 1 AS v_cnt,
    v_cnt AS niss_atprm_lnd_sk,
    reg_per_yr,
    CASE 
      WHEN i_niss_terr_cd IS NULL THEN '?'
      WHEN TRIM(i_niss_terr_cd) = '' THEN '?'
      ELSE TRIM(i_niss_terr_cd)
    END AS niss_terr_cd
  FROM exp_to_derive_vals
),
audit_data AS (
  SELECT * FROM {{ mplt_abc_mapping_audit('m_nu0c_niss_auto_100_atprm_lnd_load', 'models/int', 'workflow_name') }}
)
SELECT * FROM exp_passtotgt