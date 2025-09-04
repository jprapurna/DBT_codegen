{{
  config(materialized='table')
}}

SELECT
  *,
  -- Final field selection and aliasing
  transformed_claim_code AS final_claim_code
FROM {{ ref('int_wf_W_CLAIM_CD_SCD3_IU') }};