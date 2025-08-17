{% snapshot farmers_state_snapshot %}
    {{
        config(
            target_database='GENAI_POWER_BI',
            target_schema='POWER_CENTER',
            unique_key='FARMERS_STATE_CD',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}
    SELECT *
    FROM {{ ref('farmers_state_reference') }}
{% endsnapshot %}