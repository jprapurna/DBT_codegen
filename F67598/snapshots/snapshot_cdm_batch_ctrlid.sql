{% snapshot snapshot_cdm_batch_ctrlid %}
{{ config(
    target_database='genai_power_bi',
    target_schema='cdm',
    unique_key='batch_id',
    strategy='check'
) }}

SELECT 
  batch_id,
  source_name,
  status
FROM {{ ref('int_cdm_batch_ctrlid') }}
{% endsnapshot %}