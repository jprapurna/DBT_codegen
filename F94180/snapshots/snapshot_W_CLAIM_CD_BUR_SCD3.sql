{% snapshot snapshot_W_CLAIM_CD_BUR_SCD3 %}
{{
  config(
    target_database='CDM',
    target_schema='snapshots',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
SELECT 
  ROW_WID,
  INTEGRATION_ID,
  NEW_BUR,
  updated_at
FROM {{ ref('int_W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}