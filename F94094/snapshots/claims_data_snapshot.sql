{% snapshot claims_data_snapshot %}
{{
  config(
    target_database='GENAI_POWER_BI',
    target_schema='CDH_GWODS',
    unique_key='claim_id',
    strategy='check',
    check_cols=['status', 'amount']
  )
}}
SELECT * FROM {{ source('genai_power_bi', 'claims_data') }}
{% endsnapshot %}