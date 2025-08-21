{% snapshot snapshot_w_claim_cd_bur_scd3 %}
{{
  config(
    target_database='genai_power_bi',
    target_schema='CDM',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
SELECT *
FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}