{% snapshot scd3_snapshot %}
    {{
        config(
            target_database='DBConnection_CDM',
            target_schema='CDM',
            unique_key='ROW_WID',
            strategy='check',
            check_cols=['NEW_BUR']
        )
    }}
    SELECT 
        ROW_WID,
        INTEGRATION_ID,
        NEW_BUR
    FROM {{ source('CDM', 'wf_W_CLAIM_CD_SCD3_IU') }}
{% endsnapshot %}