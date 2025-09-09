{% macro mplt_lookup_claim_code(claim_id) %}
WITH lookup_claim_code AS (
  SELECT
    lkp_claim_code.claim_code AS claim_code
  FROM {{ source('LKP_W_CLAIM_CD_BUR_SCD3', 'LKP_W_CLAIM_CD_BUR_SCD3') }} AS lkp_claim_code
  WHERE lkp_claim_code.claim_id = {{ claim_id }}
)
SELECT claim_code
FROM lookup_claim_code
{% endmacro %}