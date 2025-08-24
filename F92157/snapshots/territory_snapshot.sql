{% snapshot territory_snapshot %}
    {{
        config(
            target_database='AGDM',
            target_schema='snapshots',
            unique_key='REF_AUTO_TERR_SK',
            strategy='timestamp',
            updated_at='DW_UPD_TMSP'
        )
    }}
    SELECT *
    FROM {{ ref('territory_details') }}
{% endsnapshot %}