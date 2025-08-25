{% snapshot niss_aprm_lnd_snapshot %}
    {{
        config(
            target_database='PowerExchange_For_Snowflake',
            target_schema='public',
            unique_key='NISS_APRM_LND_SK',
            strategy='timestamp',
            updated_at='SRC_TRANS_TMSP'
        )
    }}

    SELECT *
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_LND') }}
{% endsnapshot %}