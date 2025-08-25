{% snapshot niss_auto_atprm_dtl_snapshot %}
    {{
        config(
            target_database='PowerExchange_For_Snowflake',
            target_schema='snapshots',
            unique_key='NISS_APRM_DETL_SK',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    SELECT *
    FROM {{ ref('int_niss_auto_atprm_dtl') }}
{% endsnapshot %}