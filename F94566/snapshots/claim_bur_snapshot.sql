{% snapshot claim_bur_snapshot %}
{{
  config(
    target_database='DBA_COMMON_UTILS',
    target_schema='DBA',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='updated_at_column'
  )
}}

SELECT *
FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
{% endsnapshot %}