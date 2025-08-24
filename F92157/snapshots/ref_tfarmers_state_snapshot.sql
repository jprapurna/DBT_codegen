{% snapshot ref_tfarmers_state_snapshot %}
    {{
        config(
            target_database='FDR',
            target_schema='public',
            unique_key='FARMERS_STATE_CD',
            strategy='timestamp',
            updated_at='END_EFF_DT'
        )
    }}
    SELECT 
        FARMERS_STATE_CD,
        STATE_CODE,
        END_EFF_DT
    FROM {{ source('FDR', 'REF_TFARMERS_STATE') }}
{% endsnapshot %}