{% snapshot farmers_state_snapshot %}
    {{
        config(
            target_database='AGDM',
            target_schema='snapshots',
            unique_key='FARMERS_STATE_CD',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}
    SELECT *
    FROM {{ ref('farmers_state_reference') }}
{% endsnapshot %}
