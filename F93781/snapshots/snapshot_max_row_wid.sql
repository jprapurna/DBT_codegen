{% snapshot snapshot_max_row_wid %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='snapshots',
        unique_key='TABLE_NAME',
        strategy='check',
        check_cols=['ROW_WID']
    )
}}
SELECT *
FROM {{ ref('int_max_row_wid') }}
{% endsnapshot %}