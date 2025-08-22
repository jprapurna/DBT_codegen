{% snapshot snapshot_W_CLAIM_CD_BUR_SCD3 %}
{{
  config(
    target_database='genai_power_bi',
    target_schema='snapshots',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='CDM_UPDATE_DT'
  )
}}
SELECT *
FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}