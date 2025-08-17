{% snapshot claim_cd_bur_scd3_snapshot %}
{{
  config(
    target_database='W_CLAIM_CD_SCD3_IU',
    target_schema='snapshots',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='CDM_UPDATE_DT'
  )
}}

SELECT 
  ROW_WID,
  BUR,
  NEW_BUR,
  CDM_INSERT_DT,
  CDM_UPDATE_DT
FROM {{ ref('int_claim_cd_bur_scd3') }}
{% endsnapshot %}