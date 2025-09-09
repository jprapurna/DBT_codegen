{% snapshot claim_cd_bur_scd3 %}
{{ config(target_database='Snowflake', target_schema='SCHEMA_CDH_GWODS', unique_key='ROW_WID') }}

SELECT 
  ROW_WID, 
  INTEGRATION_ID, 
  NEW_BUR, 
  OLD_BUR, 
  UPDATED_AT
FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
{% endsnapshot %}