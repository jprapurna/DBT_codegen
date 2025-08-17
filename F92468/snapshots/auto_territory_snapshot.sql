{% snapshot auto_territory_snapshot %}
    {{
        config(
            target_database='GENAI_POWER_BI',
            target_schema='POWER_CENTER',
            unique_key='NISS_TERR_CD',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}
    SELECT *
    FROM {{ ref('auto_territory_reference') }}
{% endsnapshot %}