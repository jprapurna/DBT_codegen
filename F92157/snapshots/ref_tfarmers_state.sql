{% snapshot ref_tfarmers_state %}
    {{
        config(
            target_database='FDR',
            target_schema='public',
            unique_key='FARMERS_STATE_CD',
            strategy='timestamp',
            updated_at='updated_at_column'
        )
    }}
    SELECT *
    FROM {{ source('FDR', 'REF_TFARMERS_STATE') }}
{% endsnapshot %}
