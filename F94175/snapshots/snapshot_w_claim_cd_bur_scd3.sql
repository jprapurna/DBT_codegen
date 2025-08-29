{% snapshot snapshot_w_claim_cd_bur_scd3 %}
{{
  config(
    target_database='CDM',
    target_schema='CDM',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='CDM_UPDATE_DT'
  )
}}
SELECT 
  ROW_WID,
  INTEGRATION_ID,
  BUR,
  NEW_BUR,
  CDM_INSERT_DT,
  CDM_UPDATE_DT
FROM {{ ref('int_exp_flag') }}
{% endsnapshot %}