{% snapshot snapshot_cdm_batch_ctrlid %}
{{ config(
    target_database='genai_power_bi',
    target_schema='staging',
    unique_key='SOURCE_NAME',
    strategy='check'
) }}

SELECT 
  SOURCE_NAME,
  BATCH_ID,
  STATUS
FROM {{ ref('int_cdm_batch_ctrlid') }}
{% endsnapshot %}