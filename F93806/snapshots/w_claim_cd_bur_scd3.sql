{% snapshot w_claim_cd_bur_scd3 %}
{{
  config(
    target_database='GENAI_POWER_BI',
    target_schema='SCHEMA_CDH_GWODS',
    unique_key='ROW_WID',
    strategy='check',
    check_cols=['NEW_BUR']
  )
}}
SELECT 
  ROW_WID,
  INTEGRATION_ID,
  NEW_BUR,
  SYSDATE() AS UPDATED_AT
FROM {{ source('genai_power_bi', 'w_claim_cd_bur_scd3') }}
{% endsnapshot %}