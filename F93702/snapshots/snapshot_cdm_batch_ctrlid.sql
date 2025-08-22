{% snapshot snapshot_cdm_batch_ctrlid %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='snapshots',
        unique_key='SOURCE_NAME',
        strategy='check',
        check_cols=['BATCH_ID']
    )
}}
SELECT *
FROM {{ ref('int_cdm_batch_ctrlid') }}
{% endsnapshot %}