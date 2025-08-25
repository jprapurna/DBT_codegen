{% snapshot auto_territory_snapshot %}
    {{
        config(
            target_database='AGDM',
            target_schema='snapshots',
            unique_key='NISS_TERR_CD',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}
    SELECT *
    FROM {{ ref('auto_territory_reference') }}
{% endsnapshot %}
