{% snapshot snapshot_cdm_claim_cd_bur_scd3 %}
{{
  config(
    target_database='CDH_GWODS',
    target_schema='CDM',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='CDM_UPDATE_DT'
  )
}}

SELECT *
FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
{% endsnapshot %}