{% snapshot ref_auto_territory_snapshot %}
    {{
        config(
            target_database='GENAI_POWER_BI',
            target_schema='POWER_CENTER',
            unique_key='REF_AUTO_TERR_SK',
            strategy='timestamp',
            updated_at='DW_UPD_TMSP'
        )
    }}

    SELECT *
    FROM {{ ref('ref_auto_territory') }}
{% endsnapshot %}